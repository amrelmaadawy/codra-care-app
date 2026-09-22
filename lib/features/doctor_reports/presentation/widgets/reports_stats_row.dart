import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_report_stats_entity.dart';

class ReportsStatsRow extends StatelessWidget {
  final DoctorReportStatsEntity stats;
  final int selectedMonth;

  const ReportsStatsRow({
    super.key,
    required this.stats,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final isSpecificMonth = selectedMonth > 0;
    final earnings = isSpecificMonth ? stats.monthEarnings : stats.yearEarnings;
    final earningsTitle = isSpecificMonth
        ? 'doctor_reports.stats_month_earnings'.tr()
        : 'doctor_reports.stats_year_earnings'.tr();

    final patients = isSpecificMonth ? stats.monthPatients : stats.yearPatients;
    final patientsTitle = isSpecificMonth
        ? 'doctor_reports.stats_month_patients'.tr()
        : 'doctor_reports.stats_year_patients'.tr();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context: context,
              title: earningsTitle,
              value: '${earnings.toStringAsFixed(0)} ج.م',
              icon: Icons.payments_rounded,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildStatCard(
              context: context,
              title: patientsTitle,
              value: '$patients',
              icon: AppIcons.patients,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _buildStatCard(
              context: context,
              title: 'doctor_reports.stats_avg_monthly'.tr(),
              value: '${stats.averageMonthly.toStringAsFixed(0)} ج.م',
              icon: Icons.trending_up_rounded,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: context.textSecondaryColor,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
