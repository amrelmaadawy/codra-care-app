import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/safe_tr_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/doctor_queue_cubit.dart';
import '../cubit/doctor_queue_state.dart';
import '../widgets/doctor_queue_app_bar.dart';
import '../widgets/doctor_queue_shimmer.dart';
import '../widgets/queue_cancel_dialog.dart';
import '../widgets/queue_empty_state.dart';
import '../widgets/queue_patient_card.dart';
import '../widgets/queue_summary_strip.dart';

class DoctorQueueView extends StatelessWidget {
  const DoctorQueueView({super.key});

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    if (isError) {
      AppSnackBar.showError(context, message);
    } else {
      AppSnackBar.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorQueueCubit, DoctorQueueState>(
      listener: (context, state) {
        if (state is DoctorQueueLoaded) {
          if (state.errorMessage != null) {
            _showSnackBar(context, state.errorMessage!, isError: true);
          } else if (state.successMessage != null) {
            _showSnackBar(context, state.successMessage!);
          }
        }
      },
      builder: (context, state) {
        if (state is DoctorQueueInitial || state is DoctorQueueLoading) {
          return const DoctorQueueShimmer();
        }

        if (state is DoctorQueueError) {
          return _buildErrorState(context, state.message);
        }

        if (state is DoctorQueueLoaded) {
          return _buildLoadedState(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadedState(BuildContext context, DoctorQueueLoaded state) {
    final cubit = context.read<DoctorQueueCubit>();
    final items = state.filteredItems;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: DoctorQueueAppBar(
        totalActive: state.queue.summary.totalActive,
        hasUrgent: state.queue.summary.hasUrgent,
      ),
      body: RefreshIndicator(
        onRefresh: cubit.loadQueue,
        color: context.primaryColor,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            QueueSummaryStrip(
              summary: state.queue.summary,
              selectedFilter: state.selectedFilter,
              onFilterSelected: cubit.setFilter,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (items.isEmpty)
              QueueEmptyState(onRefresh: cubit.loadQueue)
            else
              ...items.map((item) => QueuePatientCard(
                    key: ValueKey(item.id),
                    item: item,
                    isCallLoading: state.isItemActionLoading(item.id, QueueAction.call),
                    isCompleteLoading: state.isItemActionLoading(item.id, QueueAction.complete),
                    isCancelLoading: state.isItemActionLoading(item.id, QueueAction.cancel),
                    isExamineLoading: state.isItemActionLoading(item.id, QueueAction.examine),
                    onCall: () => cubit.callPatient(item.id),
                    onExamine: () async {
                      final visitId = await cubit.startExamination(item.id);
                      if (visitId != null && context.mounted) {
                        final completed = await context.push<bool>(
                          AppRoutes.examinationPath(visitId),
                        );
                        if (completed == true) {
                          cubit.silentRefresh();
                        }
                      }
                    },
                    onComplete: () => cubit.completePatient(item.id),
                    onCancel: () async {
                      final confirmed = await QueueCancelDialog.show(
                        context,
                        patientName: item.patientName,
                        ticketNumber: item.ticketNumber,
                      );
                      if (confirmed == true && context.mounted) {
                        cubit.cancelPatient(item.id);
                      }
                    },
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                message.trOrSelf(),
                style: AppTypography.bodyMedium.copyWith(color: context.textColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () => context.read<DoctorQueueCubit>().loadQueue(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.primaryColor,
                  backgroundColor: context.primaryColor.withValues(alpha: 0.06),
                  side: BorderSide(
                    color: context.primaryColor.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.chipRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: 10,
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'common.retry'.tr(),
                  style: AppTypography.labelLarge.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
