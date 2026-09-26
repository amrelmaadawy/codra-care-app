import 'package:equatable/equatable.dart';

class FollowUpSummaryEntity extends Equatable {
  final int totalPending;
  final int overdueCount;
  final int todayCount;
  final int upcomingCount;

  const FollowUpSummaryEntity({
    required this.totalPending,
    required this.overdueCount,
    required this.todayCount,
    required this.upcomingCount,
  });

  const FollowUpSummaryEntity.empty()
      : totalPending = 0,
        overdueCount = 0,
        todayCount = 0,
        upcomingCount = 0;

  @override
  List<Object?> get props => [
        totalPending,
        overdueCount,
        todayCount,
        upcomingCount,
      ];
}
