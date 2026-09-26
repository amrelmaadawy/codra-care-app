import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubits/reception_dashboard_cubit.dart';
import '../cubits/reception_dashboard_state.dart';
import 'active_queue_section.dart';
import 'appointments_today_grid.dart';
import 'quick_stats_section.dart';
import 'reception_quick_actions_card.dart';

class ReceptionDashboardContent extends StatelessWidget {
  final ReceptionDashboardLoaded state;
  final ReceptionDashboardCubit cubit;

  const ReceptionDashboardContent({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return isMobile ? _buildMobile(context) : _buildTablet(context);
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppointmentsTodayGrid(stats: state.data.appointmentsToday),
        const SizedBox(height: AppSpacing.lg),
        ReceptionQuickActionsCard(onActionCompleted: cubit.refresh),
        const SizedBox(height: AppSpacing.lg),
        QuickStatsSection(
          totalPatientsToday: state.data.totalPatientsToday,
          pendingFollowUps: state.data.pendingFollowUpsCount,
        ),
        const SizedBox(height: AppSpacing.lg),
        ActiveQueueSection(
          queueItems: state.data.activeQueue,
          doctors: state.data.doctors,
          activeWaitingCount: state.data.activeWaitingCount,
          selectedDoctorId: state.selectedDoctorId,
          isQueueRefreshing: state.isQueueRefreshing,
          onDoctorSelected: cubit.selectDoctor,
        ),
      ],
    );
  }

  Widget _buildTablet(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppointmentsTodayGrid(stats: state.data.appointmentsToday),
                  const SizedBox(height: AppSpacing.lg),
                  ReceptionQuickActionsCard(onActionCompleted: cubit.refresh),
                  const SizedBox(height: AppSpacing.lg),
                  QuickStatsSection(
                    totalPatientsToday: state.data.totalPatientsToday,
                    pendingFollowUps: state.data.pendingFollowUpsCount,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: 6,
              child: ActiveQueueSection(
                queueItems: state.data.activeQueue,
                doctors: state.data.doctors,
                activeWaitingCount: state.data.activeWaitingCount,
                selectedDoctorId: state.selectedDoctorId,
                isQueueRefreshing: state.isQueueRefreshing,
                onDoctorSelected: cubit.selectDoctor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
