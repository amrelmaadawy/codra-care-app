import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QuickStatsSection extends StatelessWidget {
  final int totalPatientsToday;
  final int pendingFollowUps;

  const QuickStatsSection({
    super.key,
    required this.totalPatientsToday,
    required this.pendingFollowUps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reception_dashboard.quick_stats'.tr(),
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickStatCard(
                label: 'reception_dashboard.total_patients_today'.tr(),
                count: totalPatientsToday,
                icon: AppIcons.patients,
                iconColor: context.primaryColor,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickStatCard(
                label: 'reception_dashboard.pending_follow_ups'.tr(),
                count: pendingFollowUps,
                icon: AppIcons.clock,
                iconColor: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color iconColor;

  const _QuickStatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $count',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: iconColor, size: AppSizes.iconLg),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: AppTypography.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: AppTypography.labelSmall.copyWith(
                      color: context.textMutedColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
