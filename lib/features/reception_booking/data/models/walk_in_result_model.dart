import '../../domain/entities/walk_in_result_entity.dart';

class WalkInResultModel extends WalkInResultEntity {
  const WalkInResultModel({
    required super.appointmentId,
    required super.appointmentNumber,
    required super.queueItemId,
    required super.ticketNumber,
    required super.patientId,
    required super.patientName,
    super.patientPhone,
    required super.doctorName,
    super.serviceName,
    required super.status,
    required super.replayed,
  });

  factory WalkInResultModel.fromJson(Map<String, dynamic> json) {
    final appointment = json['appointment'] as Map<String, dynamic>? ?? {};
    final queue = json['queue_item'] as Map<String, dynamic>? ?? {};
    final patient = json['patient'] as Map<String, dynamic>? ?? {};

    return WalkInResultModel(
      appointmentId: appointment['id'] as int? ?? 0,
      appointmentNumber: (appointment['appointment_number'] as String?) ?? '',
      queueItemId: queue['id'] as int? ?? 0,
      ticketNumber: (queue['ticket_number'] as String?) ?? '',
      patientId: patient['id'] as int? ?? 0,
      patientName: (patient['name'] as String?) ?? '',
      patientPhone: patient['phone'] as String?,
      doctorName: (queue['doctor_name'] as String?) ?? '',
      serviceName: queue['service_name'] as String?,
      status: (queue['status'] as String?) ??
          (appointment['status'] as String?) ??
          'waiting',
      replayed: (json['replayed'] as bool?) ?? false,
    );
  }
}
