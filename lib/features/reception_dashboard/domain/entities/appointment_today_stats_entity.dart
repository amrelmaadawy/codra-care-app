import 'package:equatable/equatable.dart';

class AppointmentTodayStatsEntity extends Equatable {
  final int scheduled;
  final int inConsultation;
  final int completed;
  final int cancelled;

  const AppointmentTodayStatsEntity({
    required this.scheduled,
    required this.inConsultation,
    required this.completed,
    required this.cancelled,
  });

  const AppointmentTodayStatsEntity.empty()
    : scheduled = 0,
      inConsultation = 0,
      completed = 0,
      cancelled = 0;

  int get total => scheduled + inConsultation + completed + cancelled;

  @override
  List<Object?> get props => [scheduled, inConsultation, completed, cancelled];
}
