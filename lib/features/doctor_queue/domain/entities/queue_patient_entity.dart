import 'package:equatable/equatable.dart';

class QueuePatientEntity extends Equatable {
  final int id;
  final String ticketNumber;
  final int? patientId;
  final String patientName;
  final String? patientPhone;
  final int? patientAge;
  final String? patientGender;
  final String serviceName;
  final String priority;
  final String? priorityLabel;
  final String status;
  final String? statusLabel;
  final bool isUrgent;
  final bool isVip;
  final String? entryTime;
  final String? entryTimeHuman;
  final String? calledTime;
  final Map<String, dynamic>? vitalSigns;
  final bool hasIntakeVitals;
  final int? appointmentId;

  const QueuePatientEntity({
    required this.id,
    required this.ticketNumber,
    this.patientId,
    required this.patientName,
    this.patientPhone,
    this.patientAge,
    this.patientGender,
    required this.serviceName,
    required this.priority,
    this.priorityLabel,
    required this.status,
    this.statusLabel,
    required this.isUrgent,
    required this.isVip,
    this.entryTime,
    this.entryTimeHuman,
    this.calledTime,
    this.vitalSigns,
    required this.hasIntakeVitals,
    this.appointmentId,
  });

  bool get isWaiting => status == 'waiting';
  bool get isWithDoctor => status == 'with_doctor';
  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    patientId,
    patientName,
    patientPhone,
    patientAge,
    patientGender,
    serviceName,
    priority,
    priorityLabel,
    status,
    statusLabel,
    isUrgent,
    isVip,
    entryTime,
    entryTimeHuman,
    calledTime,
    vitalSigns,
    hasIntakeVitals,
    appointmentId,
  ];
}
