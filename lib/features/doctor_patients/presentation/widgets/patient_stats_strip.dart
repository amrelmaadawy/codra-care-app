import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_stats_entity.dart';

class PatientStatsStrip extends StatelessWidget {
  final PatientStatsEntity stats;

  const PatientStatsStrip({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 16,
              color: context.primaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              'doctor_patients.stats_title'.tr(),
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: 'doctor_patients.visits_count'.tr(),
                value: '${stats.visitsCount}',
                icon: Icons.history_rounded,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'doctor_patients.prescriptions_count'.tr(),
                value: '${stats.prescriptionsCount}',
                icon: Icons.medication_rounded,
                color: AppColors.emerald,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'doctor_patients.first_visit'.tr(),
                value: stats.firstVisit ?? '—',
                icon: Icons.flag_outlined,
                color: AppColors.info,
                isDate: true,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _buildStatCard(
                context,
                title: 'doctor_patients.last_visit'.tr(),
                value: stats.lastVisit ?? '—',
                icon: Icons.event_available_rounded,
                color: AppColors.accent,
                isDate: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isDate = false,
  }) {
    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark
              ? context.dividerColor.withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF0F172A))
                .withValues(alpha: isDark ? 0.15 : 0.025),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
              fontSize: isDate ? 11 : 15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: context.textMutedColor,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
