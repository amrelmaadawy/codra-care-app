import 'package:equatable/equatable.dart';

class AppointmentCalendarDayEntity extends Equatable {
  final String date;
  final int total;
  final int scheduledCount;
  final int inConsultationCount;
  final int completedCount;
  final int cancelledCount;

  const AppointmentCalendarDayEntity({
    required this.date,
    required this.total,
    this.scheduledCount = 0,
    this.inConsultationCount = 0,
    this.completedCount = 0,
    this.cancelledCount = 0,
  });

  @override
  List<Object?> get props => [
    date,
    total,
    scheduledCount,
    inConsultationCount,
    completedCount,
    cancelledCount,
  ];
}
