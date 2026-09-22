import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_leave_day_entity.dart';

class LeaveDayCard extends StatelessWidget {
  final DoctorLeaveDayEntity leave;
  final VoidCallback onDelete;

  const LeaveDayCard({
    super.key,
    required this.leave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final date = leave.parsedDate;
    final displayDate = date != null
        ? DateFormat('d MMMM yyyy', lang).format(date)
        : (leave.formattedDate ?? leave.leaveDate);
    final displayDay = date != null
        ? DateFormat('EEEE', lang).format(date)
        : leave.dayName;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.7)),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              AppIcons.calendar,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      displayDate,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    if (displayDay != null) ...[
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '($displayDay)',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
                if (leave.reason != null && leave.reason!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    leave.reason!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: 'leave_days.delete_leave_title'.tr(),
            icon: const Icon(
              AppIcons.delete,
              color: AppColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
