import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../widgets/dashboard_quick_actions.dart';
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
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            _buildStatsGrid(context),
            const SizedBox(height: AppSpacing.lg),
            const DashboardQuickActions(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
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
