import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_calendar_day_entity.dart';
import 'appointment_calendar_day_tile.dart';

class AppointmentsCalendarBar extends StatelessWidget {
  final String selectedDate;
  final String currentMonth;
  final List<AppointmentCalendarDayEntity> calendarDays;
  final bool isExpanded;
  final ValueChanged<String> onDateSelected;
  final ValueChanged<String> onMonthChanged;
  final VoidCallback onToggleExpand;

  const AppointmentsCalendarBar({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.calendarDays,
    required this.isExpanded,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.onToggleExpand,
  });

  Map<String, int> get _countMap => {
    for (final day in calendarDays) day.date: day.total,
  };

  @override
  Widget build(BuildContext context) {
    final selectedDt = DateTime.tryParse(selectedDate) ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(bottom: BorderSide(color: context.dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context, selectedDt),
          const SizedBox(height: AppSpacing.sm),
          if (isExpanded)
            _buildMonthGrid(context)
          else
            _buildWeekRow(context, selectedDt),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateTime selectedDt) {
    final monthParts = currentMonth.split('-');
    final year = int.tryParse(monthParts.first) ?? selectedDt.year;
    final month = int.tryParse(monthParts.last) ?? selectedDt.month;
    final currentMonthDt = DateTime(year, month);
    String monthTitle;
    try {
      final langCode = Localizations.maybeLocaleOf(context)?.languageCode;
      monthTitle = DateFormat.yMMMM(langCode).format(currentMonthDt);
    } catch (_) {
      monthTitle = '${currentMonthDt.year}-${currentMonthDt.month}';
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            final prev = DateTime(year, month - 1);
            onMonthChanged(
              '${prev.year}-${prev.month.toString().padLeft(2, '0')}',
            );
          },
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            monthTitle,
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            final next = DateTime(year, month + 1);
            onMonthChanged(
              '${next.year}-${next.month.toString().padLeft(2, '0')}',
            );
          },
        ),
        IconButton(
          icon: Icon(
            isExpanded ? Icons.calendar_view_week : Icons.calendar_month,
            size: 20,
            color: context.primaryColor,
          ),
          tooltip: isExpanded
              ? 'reception_appointments.collapse_week'.tr()
              : 'reception_appointments.expand_month'.tr(),
          onPressed: onToggleExpand,
        ),
      ],
    );
  }

  Widget _buildWeekRow(BuildContext context, DateTime selectedDt) {
    final startOfWeek = selectedDt.subtract(
      Duration(days: selectedDt.weekday % 7),
    );
    final weekDays = List.generate(
      7,
      (i) => startOfWeek.add(Duration(days: i)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((d) {
        final dStr =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        return AppointmentCalendarDayTile(
          date: d,
          isSelected: dStr == selectedDate,
          count: _countMap[dStr] ?? 0,
          onDateSelected: onDateSelected,
        );
      }).toList(),
    );
  }

  Widget _buildMonthGrid(BuildContext context) {
    final parts = currentMonth.split('-');
    final year = int.tryParse(parts.first) ?? DateTime.now().year;
    final month = int.tryParse(parts.last) ?? DateTime.now().month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final monthDays = List.generate(
      daysInMonth,
      (i) => DateTime(year, month, i + 1),
    );

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: monthDays.map((d) {
        final dStr =
            '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
        return SizedBox(
          width: 38,
          height: 52,
          child: AppointmentCalendarDayTile(
            date: d,
            isSelected: dStr == selectedDate,
            count: _countMap[dStr] ?? 0,
            onDateSelected: onDateSelected,
          ),
        );
      }).toList(),
    );
  }
}
