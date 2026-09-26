import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/follow_up_summary_entity.dart';

class FollowUpSummaryChips extends StatelessWidget {
  final FollowUpSummaryEntity summary;
  final String? activeUrgency;
  final ValueChanged<String?> onUrgencySelected;

  const FollowUpSummaryChips({
    super.key,
    required this.summary,
    required this.activeUrgency,
    required this.onUrgencySelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = [
      (
        key: null,
        label: 'reception_follow_ups.filter_all'.tr(),
        count: summary.totalPending,
        color: context.primaryColor,
      ),
      (
        key: 'overdue',
        label: 'reception_follow_ups.filter_overdue'.tr(),
        count: summary.overdueCount,
        color: AppColors.error,
      ),
      (
        key: 'today',
        label: 'reception_follow_ups.filter_today'.tr(),
        count: summary.todayCount,
        color: AppColors.accent,
      ),
      (
        key: 'upcoming',
        label: 'reception_follow_ups.filter_upcoming'.tr(),
        count: summary.upcomingCount,
        color: AppColors.info,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: chips.map((chip) {
          final isSelected = activeUrgency == chip.key ||
              (activeUrgency == null && chip.key == null);

          return Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.full),
              onTap: () => onUrgencySelected(chip.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? chip.color.withValues(alpha: 0.15)
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border: Border.all(
                    color: isSelected
                        ? chip.color
                        : context.dividerColor.withValues(alpha: 0.6),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chip.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? chip.color : context.textColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs + 2,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? chip.color
                            : context.dividerColor.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        chip.count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : context.textMutedColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
