import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class BookingDatePickerCard extends StatelessWidget {
  final String? selectedDate;
  final VoidCallback onTap;

  const BookingDatePickerCard({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: hasDate
                ? context.primaryColor.withValues(alpha: 0.5)
                : context.dividerColor,
          ),
          boxShadow: hasDate ? context.cardShadow : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: context.primaryColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  selectedDate ?? 'reception_booking.select_date'.tr(),
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                    color: hasDate ? context.textColor : context.textMutedColor,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.edit_calendar_rounded,
              size: 18,
              color: context.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
