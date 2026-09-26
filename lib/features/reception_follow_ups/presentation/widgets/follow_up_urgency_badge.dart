import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/reception_follow_up_entity.dart';

class FollowUpUrgencyBadge extends StatelessWidget {
  final FollowUpUrgency urgency;
  final int daysDelta;

  const FollowUpUrgencyBadge({
    super.key,
    required this.urgency,
    required this.daysDelta,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor, icon, text) = switch (urgency) {
      FollowUpUrgency.overdue => (
          AppColors.errorLight,
          AppColors.statusUrgent,
          Icons.warning_amber_rounded,
          'reception_follow_ups.urgency_overdue_days'.tr(args: [
            daysDelta.abs().toString(),
          ]),
        ),
      FollowUpUrgency.today => (
          AppColors.warningLight,
          AppColors.accent,
          Icons.today_rounded,
          'reception_follow_ups.urgency_today'.tr(),
        ),
      FollowUpUrgency.upcoming => (
          AppColors.infoLight,
          AppColors.statusScheduled,
          Icons.event_available_rounded,
          daysDelta > 0
              ? 'reception_follow_ups.urgency_in_days'.tr(args: [
                  daysDelta.toString(),
                ])
              : 'reception_follow_ups.urgency_upcoming'.tr(),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: fgColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fgColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}
