import 'package:equatable/equatable.dart';

class CheckInResultEntity extends Equatable {
  final int appointmentId;
  final int queueItemId;
  final String ticketNumber;
  final String patientName;
  final String? patientPhone;
  final String doctorName;
  final String? serviceName;
  final String status;
  final String priority;
  final bool alreadyCheckedIn;

  const CheckInResultEntity({
    required this.appointmentId,
    required this.queueItemId,
    required this.ticketNumber,
    required this.patientName,
    this.patientPhone,
    required this.doctorName,
    this.serviceName,
    required this.status,
    required this.priority,
    required this.alreadyCheckedIn,
  });

  @override
  List<Object?> get props => [
        appointmentId,
        queueItemId,
        ticketNumber,
        patientName,
        patientPhone,
        doctorName,
        serviceName,
        status,
        priority,
        alreadyCheckedIn,
      ];
}
