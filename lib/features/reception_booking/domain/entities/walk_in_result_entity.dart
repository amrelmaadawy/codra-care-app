import 'package:equatable/equatable.dart';

class WalkInResultEntity extends Equatable {
  final int appointmentId;
  final String appointmentNumber;
  final int queueItemId;
  final String ticketNumber;
  final int patientId;
  final String patientName;
  final String? patientPhone;
  final String doctorName;
  final String? serviceName;
  final String status;
  final bool replayed;

  const WalkInResultEntity({
    required this.appointmentId,
    required this.appointmentNumber,
    required this.queueItemId,
    required this.ticketNumber,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    required this.doctorName,
    this.serviceName,
    required this.status,
    required this.replayed,
  });

  @override
  List<Object?> get props => [
    appointmentId,
    appointmentNumber,
    queueItemId,
    ticketNumber,
    patientId,
    patientName,
    patientPhone,
    doctorName,
    serviceName,
    status,
    replayed,
  ];
}
