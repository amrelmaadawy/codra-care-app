import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/doctor_leave_day_entity.dart';

class LeaveDayDetailsSheet extends StatelessWidget {
  final DoctorLeaveDayEntity? leave;
  final String dateStr;
  final VoidCallback onDelete;

  const LeaveDayDetailsSheet({
    super.key,
    this.leave,
    required this.dateStr,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    DoctorLeaveDayEntity? leave,
    required String dateStr,
    required VoidCallback onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => LeaveDayDetailsSheet(
        leave: leave,
        dateStr: dateStr,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final date = leave?.parsedDate ?? DateTime.tryParse(dateStr);
    final titleDate = date != null
        ? DateFormat('d MMMM yyyy', lang).format(date)
        : (leave?.formattedDate ?? dateStr);
    final dayName = date != null
        ? DateFormat('EEEE', lang).format(date)
        : leave?.dayName;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(AppIcons.calendar, color: AppColors.warning, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'leave_days.leave_details_title'.tr(),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            titleDate,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
          if (dayName != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              dayName,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
          if (leave?.reason != null && leave!.reason!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                leave!.reason!,
                style: AppTypography.bodyMedium.copyWith(color: context.textColor),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            labelKey: 'leave_days.delete_leave_title',
            variant: AppButtonVariant.outlined,
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
