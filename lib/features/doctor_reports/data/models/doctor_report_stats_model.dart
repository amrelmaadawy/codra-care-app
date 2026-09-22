import '../../domain/entities/doctor_report_stats_entity.dart';

class DoctorReportStatsModel extends DoctorReportStatsEntity {
  const DoctorReportStatsModel({
    required super.filterMonth,
    required super.filterYear,
    required super.monthName,
    required super.monthEarnings,
    required super.monthPatients,
    required super.monthRevenue,
    required super.yearEarnings,
    required super.yearPatients,
    required super.yearRevenue,
    required super.bestMonthName,
    required super.bestMonthEarnings,
    required super.averageMonthly,
    required super.commissionType,
    required super.commissionPercentage,
    required super.commissionFixedAmount,
  });

  factory DoctorReportStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorReportStatsModel(
      filterMonth: (json['filter_month'] as num?)?.toInt() ?? DateTime.now().month,
      filterYear: (json['filter_year'] as num?)?.toInt() ?? DateTime.now().year,
      monthName: json['month_name'] as String? ?? '',
      monthEarnings: (json['month_earnings'] as num?)?.toDouble() ?? 0.0,
      monthPatients: (json['month_patients'] as num?)?.toInt() ?? 0,
      monthRevenue: (json['month_revenue'] as num?)?.toDouble() ?? 0.0,
      yearEarnings: (json['year_earnings'] as num?)?.toDouble() ?? 0.0,
      yearPatients: (json['year_patients'] as num?)?.toInt() ?? 0,
      yearRevenue: (json['year_revenue'] as num?)?.toDouble() ?? 0.0,
      bestMonthName: json['best_month_name'] as String? ?? '—',
      bestMonthEarnings: (json['best_month_earnings'] as num?)?.toDouble() ?? 0.0,
      averageMonthly: (json['average_monthly'] as num?)?.toDouble() ?? 0.0,
      commissionType: json['commission_type']?.toString() ?? 'percentage',
      commissionPercentage: (json['commission_percentage'] as num?)?.toDouble() ?? 0.0,
      commissionFixedAmount: (json['commission_fixed_amount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
