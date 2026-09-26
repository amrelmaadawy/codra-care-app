import '../../domain/entities/follow_up_summary_entity.dart';

class FollowUpSummaryModel extends FollowUpSummaryEntity {
  const FollowUpSummaryModel({
    required super.totalPending,
    required super.overdueCount,
    required super.todayCount,
    required super.upcomingCount,
  });

  factory FollowUpSummaryModel.fromJson(Map<String, dynamic> json) {
    return FollowUpSummaryModel(
      totalPending: json['total_pending'] as int? ?? 0,
      overdueCount: json['overdue_count'] as int? ?? 0,
      todayCount: json['today_count'] as int? ?? 0,
      upcomingCount: json['upcoming_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_pending': totalPending,
      'overdue_count': overdueCount,
      'today_count': todayCount,
      'upcoming_count': upcomingCount,
    };
  }
}
