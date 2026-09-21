import 'package:equatable/equatable.dart';

class QueueSummaryEntity extends Equatable {
  final int completedToday;
  final int waitingCount;
  final int withDoctorCount;
  final int totalActive;
  final int urgentCount;
  final bool hasUrgent;

  const QueueSummaryEntity({
    required this.completedToday,
    required this.waitingCount,
    required this.withDoctorCount,
    required this.totalActive,
    required this.urgentCount,
    required this.hasUrgent,
  });

  const QueueSummaryEntity.empty()
      : completedToday = 0,
        waitingCount = 0,
        withDoctorCount = 0,
        totalActive = 0,
        urgentCount = 0,
        hasUrgent = false;

  @override
  List<Object?> get props => [
    completedToday,
    waitingCount,
    withDoctorCount,
    totalActive,
    urgentCount,
    hasUrgent,
  ];
}
