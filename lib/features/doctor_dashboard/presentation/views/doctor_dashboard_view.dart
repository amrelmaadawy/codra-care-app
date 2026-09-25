import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../doctor_chat/presentation/widgets/doctor_chat_fab.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/doctor_dashboard_app_bar.dart';

class DoctorDashboardView extends StatelessWidget {
  final DoctorDashboardEntity data;
  final Future<void> Function() onRefresh;

  const DoctorDashboardView({
    super.key,
    required this.data,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorDashboardAppBar(
        doctorName: data.doctorName,
        specialization: data.specialization,
        unreadNotificationsCount: data.unreadNotificationsCount,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            _buildStatsGrid(context),
            const SizedBox(height: AppSpacing.lg),
            _buildQuickActions(context),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
      floatingActionButton: const DoctorChatFab(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickActionItem(
        label: 'doctor_dashboard.new_prescription'.tr(),
        icon: AppIcons.prescriptions,
        color: AppColors.emerald,
        onTap: () => context.push(AppRoutes.prescriptionNew),
      ),
      _QuickActionItem(
        label: 'doctor_dashboard.patient_records'.tr(),
        icon: AppIcons.patients,
        color: AppColors.info,
        onTap: () => context.go(AppRoutes.patients),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'doctor_dashboard.quick_actions'.tr(),
          style: AppTypography.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: actions
              .map(
                (act) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Material(
                      color: context.surfaceColor,
                      borderRadius: AppRadius.cardRadius,
                      child: InkWell(
                        onTap: act.onTap,
                        borderRadius: AppRadius.cardRadius,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                            horizontal: AppSpacing.md,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: AppRadius.cardRadius,
                            border: Border.all(
                              color: context.dividerColor.withValues(alpha: 0.5),
                            ),
                            boxShadow: context.primaryShadow,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: act.color.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(act.icon, color: act.color, size: 20),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  act.label,
                                  style: AppTypography.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final crossAxisCount = isTablet ? 4 : 2;

    final stats = [
      _StatItem(
        title: 'doctor_dashboard.today_queue'.tr(),
        value: '${data.todayQueueCount}',
        icon: AppIcons.queue,
        color: AppColors.primary,
        bgColor: AppColors.primary.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.queue),
      ),
      _StatItem(
        title: 'doctor_dashboard.waiting'.tr(),
        value: '${data.waitingCount}',
        icon: AppIcons.queue,
        color: AppColors.statusWaiting,
        bgColor: AppColors.statusWaiting.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.queue),
      ),
      _StatItem(
        title: 'doctor_dashboard.with_doctor'.tr(),
        value: '${data.withDoctorCount}',
        icon: AppIcons.consultation,
        color: AppColors.statusInConsultation,
        bgColor: AppColors.statusInConsultation.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.queue),
      ),
      _StatItem(
        title: 'doctor_dashboard.completed'.tr(),
        value: '${data.completedToday}',
        icon: AppIcons.checkCircle,
        color: AppColors.statusCompleted,
        bgColor: AppColors.statusCompleted.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.queue),
      ),
      _StatItem(
        title: 'doctor_dashboard.today_appointments'.tr(),
        value: '${data.todayAppointmentsCount}',
        icon: AppIcons.appointments,
        color: AppColors.statusScheduled,
        bgColor: AppColors.statusScheduled.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.appointments),
      ),
      _StatItem(
        title: 'doctor_dashboard.pending_follow_ups'.tr(),
        value: '${data.pendingFollowUps}',
        icon: AppIcons.vitals,
        color: AppColors.accent,
        bgColor: AppColors.accent.withValues(alpha: 0.12),
      ),
      _StatItem(
        title: 'doctor_dashboard.patients_today'.tr(),
        value: '${data.patientsToday}',
        icon: AppIcons.patients,
        color: AppColors.statusWaiting,
        bgColor: AppColors.statusWaiting.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.patients),
      ),
      _StatItem(
        title: 'doctor_dashboard.patients_month'.tr(),
        value: '${data.patientsMonth}',
        icon: AppIcons.patients,
        color: AppColors.statusInConsultation,
        bgColor: AppColors.statusInConsultation.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.patients),
      ),
      if (data.revenueMonth != null)
        _StatItem(
          title: 'doctor_dashboard.monthly_revenue'.tr(),
          value: '${data.revenueMonth!.toStringAsFixed(0)} ${'doctor_dashboard.currency'.tr()}',
          icon: AppIcons.financial,
          color: AppColors.success,
          bgColor: AppColors.success.withValues(alpha: 0.12),
        ),
      _StatItem(
        title: 'doctor_dashboard.patients_total'.tr(),
        value: '${data.patientsTotal}',
        icon: AppIcons.patients,
        color: AppColors.info,
        bgColor: AppColors.info.withValues(alpha: 0.12),
        onTap: () => context.go(AppRoutes.patients),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.35,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        return DashboardStatCard(
          title: item.title,
          value: item.value,
          icon: item.icon,
          iconColor: item.color,
          iconBgColor: item.bgColor,
          onTap: item.onTap,
        );
      },
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;

  const _StatItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
  });
}

class _QuickActionItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
