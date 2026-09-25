import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentCalendarDayTile extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final int count;
  final ValueChanged<String> onDateSelected;

  const AppointmentCalendarDayTile({
    super.key,
    required this.date,
    required this.isSelected,
    required this.count,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    String dayName;
    try {
      final langCode = Localizations.maybeLocaleOf(context)?.languageCode;
      dayName = DateFormat.E(langCode).format(date);
    } catch (_) {
      dayName = '${date.day}';
    }

    return InkWell(
      onTap: () => onDateSelected(dateStr),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: isSelected ? context.primaryColor : context.dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayName,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: isSelected ? Colors.white : context.textMutedColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${date.day}',
              style: AppTypography.titleSmall.copyWith(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : context.textColor,
              ),
            ),
            const SizedBox(height: 2),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: count > 0
                    ? (isSelected ? Colors.white : context.primaryColor)
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
