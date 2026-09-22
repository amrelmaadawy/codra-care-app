import '../../domain/entities/doctor_leave_days_summary_entity.dart';
import 'doctor_leave_day_model.dart';

class DoctorLeaveDaysSummaryModel extends DoctorLeaveDaysSummaryEntity {
  const DoctorLeaveDaysSummaryModel({
    required super.totalCount,
    required super.thisMonthCount,
    required super.upcomingCount,
    required super.leaveDates,
    required super.upcomingLeaves,
  });

  factory DoctorLeaveDaysSummaryModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    final rawDates = json['leave_dates'] as List<dynamic>? ?? [];
    final rawUpcoming = json['upcoming'] as List<dynamic>? ?? [];

    return DoctorLeaveDaysSummaryModel(
      totalCount: (stats['total'] as num?)?.toInt() ?? 0,
      thisMonthCount: (stats['this_month'] as num?)?.toInt() ?? 0,
      upcomingCount: (stats['upcoming'] as num?)?.toInt() ?? 0,
      leaveDates: rawDates.map((e) => e.toString()).toList(),
      upcomingLeaves: rawUpcoming
          .map((item) => DoctorLeaveDayModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
