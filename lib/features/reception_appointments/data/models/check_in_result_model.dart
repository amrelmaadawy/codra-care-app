import '../../domain/entities/check_in_result_entity.dart';

class CheckInResultModel extends CheckInResultEntity {
  const CheckInResultModel({
    required super.appointmentId,
    required super.queueItemId,
    required super.ticketNumber,
    required super.patientName,
    super.patientPhone,
    required super.doctorName,
    super.serviceName,
    required super.status,
    required super.priority,
    required super.alreadyCheckedIn,
  });

  factory CheckInResultModel.fromJson(Map<String, dynamic> json) {
    final queue = json['queue_item'] as Map<String, dynamic>? ?? {};
    return CheckInResultModel(
      appointmentId: json['appointment_id'] as int? ?? 0,
      queueItemId: queue['id'] as int? ?? 0,
      ticketNumber: (queue['ticket_number'] as String?) ?? '',
      patientName: (queue['patient_name'] as String?) ?? '',
      patientPhone: queue['patient_phone'] as String?,
      doctorName: (queue['doctor_name'] as String?) ?? '',
      serviceName: queue['service_name'] as String?,
      status: (queue['status'] as String?) ?? 'waiting',
      priority: (queue['priority'] as String?) ?? 'normal',
      alreadyCheckedIn: (json['already_checked_in'] as bool?) ?? false,
    );
  }
}
