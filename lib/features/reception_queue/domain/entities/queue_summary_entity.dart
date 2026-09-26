import 'package:equatable/equatable.dart';

class QueueSummaryEntity extends Equatable {
  final int waiting;
  final int withDoctor;
  final int completed;
  final int cancelled;
  final int total;
  final int avgWaitMinutes;

  const QueueSummaryEntity({
    this.waiting = 0,
    this.withDoctor = 0,
    this.completed = 0,
    this.cancelled = 0,
    this.total = 0,
    this.avgWaitMinutes = 0,
  });

  @override
  List<Object?> get props => [
    waiting,
    withDoctor,
    completed,
    cancelled,
    total,
    avgWaitMinutes,
  ];
}
