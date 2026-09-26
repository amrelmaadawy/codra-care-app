import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import '../cubit/queue_vitals_cubit.dart';
import '../cubit/queue_vitals_state.dart';
import 'queue_vitals_inputs_grid.dart';

class QueueVitalsModal extends StatelessWidget {
  final ReceptionQueueItemEntity item;
  final ValueChanged<ReceptionQueueItemEntity> onSaved;

  const QueueVitalsModal({
    super.key,
    required this.item,
    required this.onSaved,
  });

  static Future<void> show({
    required BuildContext context,
    required ReceptionQueueItemEntity item,
    required ValueChanged<ReceptionQueueItemEntity> onSaved,
  }) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;

    if (isTablet) {
      return showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
            child: QueueVitalsModal(item: item, onSaved: onSaved),
          ),
        ),
      );
    }

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: QueueVitalsModal(item: item, onSaved: onSaved),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QueueVitalsCubit(
        queueId: item.id,
        initialVitals: item.vitalSigns,
        saveQueueVitalsUseCase: GetIt.I(),
      ),
      child: BlocConsumer<QueueVitalsCubit, QueueVitalsState>(
        listener: (context, state) {
          if (state.isSuccess && state.savedItem != null) {
            onSaved(state.savedItem!);
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.errorMessage != null)
                    _buildErrorBanner(state.errorMessage!),
                  QueueVitalsInputsGrid(
                    cubit: context.read<QueueVitalsCubit>(),
                    state: state,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildSubmitButton(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.monitor_heart_outlined, color: AppColors.info, size: 22),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'reception_queue.vitals_modal_title'.tr(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                item.patientName,
                style: TextStyle(fontSize: 12, color: context.textSecondaryColor),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_rounded, size: 20),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.errorLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        error.tr(),
        style: const TextStyle(fontSize: 12, color: AppColors.error),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, QueueVitalsState state) {
    if (state.isSubmitting) {
      return AppShimmer(
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: AppShimmerBox(
            width: 100,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => context.read<QueueVitalsCubit>().submit(),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        'reception_queue.save_vitals_button'.tr(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
