import 'package:equatable/equatable.dart';
import 'doctor_leave_day_entity.dart';

class DoctorLeaveDaysSummaryEntity extends Equatable {
  final int totalCount;
  final int thisMonthCount;
  final int upcomingCount;
  final List<String> leaveDates;
  final List<DoctorLeaveDayEntity> upcomingLeaves;

  const DoctorLeaveDaysSummaryEntity({
    required this.totalCount,
    required this.thisMonthCount,
    required this.upcomingCount,
    required this.leaveDates,
    required this.upcomingLeaves,
  });

  Set<String> get leaveDatesSet => leaveDates.toSet();

  @override
  List<Object?> get props => [
        totalCount,
        thisMonthCount,
        upcomingCount,
        leaveDates,
        upcomingLeaves,
      ];
}
