import 'package:equatable/equatable.dart';
import 'queue_capabilities_entity.dart';
import 'vital_signs_entity.dart';

class ReceptionQueueItemEntity extends Equatable {
  final int id;
  final String ticketNumber;
  final int patientId;
  final String patientName;
  final String? patientPhone;
  final int doctorId;
  final String doctorName;
  final int? serviceId;
  final String? serviceName;
  final int? appointmentId;
  final String status;
  final String priority;
  final bool isPresent;
  final VitalSignsEntity? vitalSigns;
  final DateTime? entryTime;
  final DateTime? calledTime;
  final DateTime? completedTime;
  final int waitMinutes;
  final QueueCapabilitiesEntity capabilities;

  const ReceptionQueueItemEntity({
    required this.id,
    required this.ticketNumber,
    required this.patientId,
    required this.patientName,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    this.serviceId,
    this.serviceName,
    this.appointmentId,
    required this.status,
    required this.priority,
    required this.isPresent,
    this.vitalSigns,
    this.entryTime,
    this.calledTime,
    this.completedTime,
    required this.waitMinutes,
    required this.capabilities,
  });

  bool get isWaiting => status == 'waiting';
  bool get isWithDoctor => status == 'with_doctor';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isUrgent => priority == 'urgent';
  bool get isVip => priority == 'vip';

  ReceptionQueueItemEntity copyWith({
    int? id,
    String? ticketNumber,
    int? patientId,
    String? patientName,
    String? patientPhone,
    int? doctorId,
    String? doctorName,
    int? serviceId,
    String? serviceName,
    int? appointmentId,
    String? status,
    String? priority,
    bool? isPresent,
    VitalSignsEntity? vitalSigns,
    DateTime? entryTime,
    DateTime? calledTime,
    DateTime? completedTime,
    int? waitMinutes,
    QueueCapabilitiesEntity? capabilities,
  }) {
    return ReceptionQueueItemEntity(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      appointmentId: appointmentId ?? this.appointmentId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      isPresent: isPresent ?? this.isPresent,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      entryTime: entryTime ?? this.entryTime,
      calledTime: calledTime ?? this.calledTime,
      completedTime: completedTime ?? this.completedTime,
      waitMinutes: waitMinutes ?? this.waitMinutes,
      capabilities: capabilities ?? this.capabilities,
    );
  }

  @override
  List<Object?> get props => [
    id,
    ticketNumber,
    patientId,
    patientName,
    patientPhone,
    doctorId,
    doctorName,
    serviceId,
    serviceName,
    appointmentId,
    status,
    priority,
    isPresent,
    vitalSigns,
    entryTime,
    calledTime,
    completedTime,
    waitMinutes,
    capabilities,
  ];
}
