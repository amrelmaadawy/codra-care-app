import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_report_chart_entity.dart';

class ReportsChart extends StatelessWidget {
  final DoctorReportChartEntity chart;
  final int selectedMonth;
  final ValueChanged<int> onMonthSelected;

  const ReportsChart({
    super.key,
    required this.chart,
    required this.selectedMonth,
    required this.onMonthSelected,
  });

  static const List<String> _shortMonths = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'
  ];

  @override
  Widget build(BuildContext context) {
    final earnings = chart.earnings;
    final maxEarning = earnings.isNotEmpty
        ? earnings.reduce((curr, next) => curr > next ? curr : next)
        : 0.0;
    final maxY = maxEarning > 0 ? (maxEarning * 1.25) : 1000.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'doctor_reports.chart_title'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              Text(
                '${chart.year}',
                style: AppTypography.labelSmall.copyWith(
                  color: context.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final monthName = (groupIndex < chart.labels.length)
                          ? chart.labels[groupIndex]
                          : '${groupIndex + 1}';
                      return BarTooltipItem(
                        '$monthName\n${rod.toY.toStringAsFixed(0)} ج.م',
                        AppTypography.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event is FlTapUpEvent && response?.spot != null) {
                      final touchedIndex = response!.spot!.touchedBarGroupIndex;
                      onMonthSelected(touchedIndex + 1);
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= _shortMonths.length) {
                          return const SizedBox.shrink();
                        }
                        final isSelected = selectedMonth == (index + 1);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _shortMonths[index],
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? context.primaryColor
                                  : context.textSecondaryColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  earnings.length,
                  (index) => _buildBarGroup(
                    context: context,
                    index: index,
                    value: earnings[index],
                    isSelected: selectedMonth == (index + 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup({
    required BuildContext context,
    required int index,
    required double value,
    required bool isSelected,
  }) {
    final rodColor = isSelected
        ? context.primaryColor
        : context.primaryColor.withValues(alpha: 0.35);

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: value > 0 ? value : 0.0,
          color: rodColor,
          width: 14,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.xs),
          ),
        ),
      ],
    );
  }
}
