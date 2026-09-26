import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import '../cubit/reception_queue_cubit.dart';
import '../cubit/reception_queue_state.dart';
import '../widgets/queue_action_confirmation_dialog.dart';
import '../widgets/queue_doctor_selector.dart';
import '../widgets/queue_empty_state.dart';
import '../widgets/queue_item_card.dart';
import '../widgets/queue_list_shimmer.dart';
import '../widgets/queue_summary_chips.dart';
import '../widgets/queue_vitals_modal.dart';
import '../widgets/reception_queue_app_bar.dart';

class ReceptionQueueView extends StatelessWidget {
  const ReceptionQueueView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceptionQueueCubit, ReceptionQueueState>(
      listenWhen: (prev, curr) =>
          prev.actionFeedbackKey != curr.actionFeedbackKey ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        final feedback = state.actionFeedbackKey;
        final error = state.errorMessage;
        if (feedback != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(feedback.tr()),
            backgroundColor: AppColors.emerald,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ));
          context.read<ReceptionQueueCubit>().clearFeedback();
        } else if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error.tr()),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ));
          context.read<ReceptionQueueCubit>().clearFeedback();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ReceptionQueueCubit>();

        return Scaffold(
          appBar: ReceptionQueueAppBar(
            isRefreshing: state.isSilentRefreshing,
            lastRefreshedAt: state.lastRefreshedAt,
            onSearchChanged: cubit.setSearch,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),
              if (state.queue.doctors.isNotEmpty) ...[
                QueueDoctorSelector(
                  doctors: state.queue.doctors,
                  selectedDoctorId: state.filter.doctorId,
                  onDoctorSelected: cubit.setDoctorFilter,
                  avgWaitMinutes: state.queue.summary.avgWaitMinutes,
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              QueueSummaryChips(
                summary: state.queue.summary,
                activeStatus: state.filter.status,
                onStatusSelected: cubit.setStatusFilter,
              ),
              const SizedBox(height: AppSpacing.xs),
              Expanded(child: _buildBody(context, state, cubit)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReceptionQueueState state,
    ReceptionQueueCubit cubit,
  ) {
    if (state.isLoading) return const QueueListShimmer();

    if (state.isError && state.queue.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.sm),
              Text(
                state.errorMessage?.tr() ?? 'errors.unexpected'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: () => cubit.loadQueue(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text('reception_queue.retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      final isFiltered = state.filter.status != null ||
          state.filter.doctorId != null ||
          state.filter.search != null;

      return QueueEmptyState(
        isFiltered: isFiltered,
        onClearFilters: () {
          cubit.setStatusFilter(null);
          cubit.setDoctorFilter(null);
          cubit.setSearch(null);
        },
        onRefresh: () => cubit.loadQueue(),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: state.queue.items.length,
      itemBuilder: (context, index) {
        final item = state.queue.items[index];
        return QueueItemCard(
          item: item,
          isPending: state.isItemPending(item.id),
          pendingAction: state.getItemPendingAction(item.id),
          onTogglePresence: (val) => cubit.togglePresence(item.id, val),
          onCallDoctor: () => _handleCallDoctor(context, cubit, item),
          onComplete: () => _handleComplete(context, cubit, item),
          onCancel: () => _handleCancel(context, cubit, item),
          onOpenVitals: () => QueueVitalsModal.show(
            context: context,
            item: item,
            onSaved: cubit.onItemUpdated,
          ),
        );
      },
    );
  }

  Future<void> _handleCallDoctor(
    BuildContext context,
    ReceptionQueueCubit cubit,
    ReceptionQueueItemEntity item,
  ) async {
    final ok = await QueueActionDialogs.showConfirmDialog(
      context: context,
      title: 'reception_queue.action_call_doctor'.tr(),
      message: '${'reception_queue.confirm_call_prefix'.tr()} ${item.patientName}؟',
      confirmText: 'reception_queue.call'.tr(),
      icon: Icons.record_voice_over_rounded,
    );
    if (ok == true) cubit.callDoctor(item.id);
  }

  Future<void> _handleComplete(
    BuildContext context,
    ReceptionQueueCubit cubit,
    ReceptionQueueItemEntity item,
  ) async {
    final ok = await QueueActionDialogs.showConfirmDialog(
      context: context,
      title: 'reception_queue.action_complete'.tr(),
      message: '${'reception_queue.confirm_complete_prefix'.tr()} ${item.patientName}؟',
      confirmText: 'reception_queue.complete'.tr(),
      confirmColor: AppColors.emerald,
      icon: Icons.done_all_rounded,
    );
    if (ok == true) cubit.completeQueueItem(item.id);
  }

  Future<void> _handleCancel(
    BuildContext context,
    ReceptionQueueCubit cubit,
    ReceptionQueueItemEntity item,
  ) async {
    final reason = await QueueActionDialogs.showCancelDialog(
      context: context,
      patientName: item.patientName,
    );
    if (reason != null && reason.isNotEmpty) cubit.cancelQueueItem(item.id, reason);
  }
}
