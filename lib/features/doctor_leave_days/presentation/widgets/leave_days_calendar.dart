import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class LeaveDaysCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<String> leaveDates;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged;

  const LeaveDaysCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.leaveDates,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  bool _isLeaveDay(DateTime day) {
    final key = DateFormat('yyyy-MM-dd').format(day);
    return leaveDates.contains(key);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1);
    final lastDay = DateTime(now.year + 2, 12, 31);

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.7)),
        boxShadow: context.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: TableCalendar(
        locale: Localizations.localeOf(context).languageCode,
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        currentDay: now,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        daysOfWeekHeight: 28.0,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleTextStyle: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textColor,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: context.textColor,
            size: 24,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: context.textColor,
            size: 24,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: context.textSecondaryColor,
            fontSize: 12,
          ),
          weekendStyle: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            return _buildDayCell(context, day, isLeave: _isLeaveDay(day));
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(
              context,
              day,
              isToday: true,
              isLeave: _isLeaveDay(day),
            );
          },
          selectedBuilder: (context, day, focusedDay) {
            return _buildDayCell(
              context,
              day,
              isSelected: true,
              isLeave: _isLeaveDay(day),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDayCell(
    BuildContext context,
    DateTime day, {
    bool isToday = false,
    bool isSelected = false,
    bool isLeave = false,
  }) {
    Color? bgColor;
    Color textColor = context.textColor;
    BoxBorder? border;

    if (isSelected) {
      bgColor = context.primaryColor;
      textColor = context.onPrimaryColor;
    } else if (isLeave) {
      bgColor = AppColors.warning.withValues(alpha: 0.2);
      border = Border.all(color: AppColors.warning, width: 1.5);
      textColor = AppColors.warning;
    } else if (isToday) {
      border = Border.all(color: context.primaryColor, width: 1.5);
    }

    return Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: isLeave || isToday || isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: textColor,
              ),
            ),
            if (isLeave && !isSelected)
              Positioned(
                bottom: 3,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
