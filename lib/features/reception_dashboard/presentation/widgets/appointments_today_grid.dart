import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/appointment_today_stats_entity.dart';

class AppointmentsTodayGrid extends StatelessWidget {
  final AppointmentTodayStatsEntity stats;

  const AppointmentsTodayGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final crossAxisCount = isMobile ? 2 : 4;

    final items = [
      _StatItem(
        label: 'reception_dashboard.scheduled'.tr(),
        count: stats.scheduled,
        color: AppColors.statusScheduled,
        icon: AppIcons.calendar,
      ),
      _StatItem(
        label: 'reception_dashboard.in_consultation'.tr(),
        count: stats.inConsultation,
        color: AppColors.statusInConsultation,
        icon: AppIcons.consultation,
      ),
      _StatItem(
        label: 'reception_dashboard.completed'.tr(),
        count: stats.completed,
        color: AppColors.statusCompleted,
        icon: AppIcons.checkCircle,
      ),
      _StatItem(
        label: 'reception_dashboard.cancelled'.tr(),
        count: stats.cancelled,
        color: AppColors.statusCancelled,
        icon: AppIcons.close,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'reception_dashboard.today_appointments'.tr(),
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: isMobile ? 1.55 : 1.7,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _AppointmentStatCard(item: item);
          },
        ),
      ],
    );
  }
}

class _StatItem {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
}

class _AppointmentStatCard extends StatelessWidget {
  final _StatItem item;

  const _AppointmentStatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${item.label}: ${item.count}',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: AppSizes.iconMd,
                  ),
                ),
                Text(
                  '${item.count}',
                  style: AppTypography.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
              ],
            ),
            Text(
              item.label,
              style: AppTypography.labelMedium.copyWith(
                color: context.textMutedColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
