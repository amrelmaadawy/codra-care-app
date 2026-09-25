import 'package:equatable/equatable.dart';

class ReceptionQueueItemEntity extends Equatable {
  final int id;
  final String ticketNumber;
  final int patientId;
  final String patientName;
  final String? patientPhone;
  final int doctorId;
  final String doctorName;
  final String? serviceName;
  final int? appointmentId;
  final String status;
  final String priority;
  final bool isPresent;
  final DateTime? entryTime;
  final DateTime? calledTime;
  final int waitMinutes;

  const ReceptionQueueItemEntity({
    required this.id,
    required this.ticketNumber,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    this.serviceName,
    this.appointmentId,
    required this.status,
    required this.priority,
    required this.isPresent,
    this.entryTime,
    this.calledTime,
    required this.waitMinutes,
  });

  bool get isWithDoctor => status == 'with_doctor';
  bool get isWaiting => status == 'waiting';
  bool get isUrgent => priority == 'urgent';
  bool get isVip => priority == 'vip';

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    patientId,
    patientName,
    patientPhone,
    doctorId,
    doctorName,
    serviceName,
    appointmentId,
    status,
    priority,
    isPresent,
    entryTime,
    calledTime,
    waitMinutes,
  ];
}
