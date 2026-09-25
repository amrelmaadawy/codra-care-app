import '../../domain/entities/reception_queue_item_entity.dart';

class ReceptionQueueItemModel extends ReceptionQueueItemEntity {
  const ReceptionQueueItemModel({
    required super.id,
    required super.ticketNumber,
    required super.patientId,
    required super.patientName,
    super.patientPhone,
    required super.doctorId,
    required super.doctorName,
    super.serviceName,
    super.appointmentId,
    required super.status,
    required super.priority,
    required super.isPresent,
    super.entryTime,
    super.calledTime,
    required super.waitMinutes,
  });

  factory ReceptionQueueItemModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw const FormatException('Missing required field: id in queue item');
    }
    if (json['patient_id'] == null) {
      throw const FormatException('Missing required field: patient_id');
    }
    if (json['doctor_id'] == null) {
      throw const FormatException('Missing required field: doctor_id');
    }

    final entryRaw = json['entry_time'] as String?;
    final calledRaw = json['called_time'] as String?;

    return ReceptionQueueItemModel(
      id: (json['id'] as num).toInt(),
      ticketNumber: (json['ticket_number'] as String?) ?? '',
      patientId: (json['patient_id'] as num).toInt(),
      patientName: (json['patient_name'] as String?) ?? '',
      patientPhone: json['patient_phone'] as String?,
      doctorId: (json['doctor_id'] as num).toInt(),
      doctorName: (json['doctor_name'] as String?) ?? '',
      serviceName: json['service_name'] as String?,
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
      status: (json['status'] as String?) ?? 'waiting',
      priority: (json['priority'] as String?) ?? 'normal',
      isPresent: (json['is_present'] as bool?) ?? false,
      entryTime: entryRaw != null ? DateTime.tryParse(entryRaw) : null,
      calledTime: calledRaw != null ? DateTime.tryParse(calledRaw) : null,
      waitMinutes: (json['wait_minutes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_phone': patientPhone,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'service_name': serviceName,
      'appointment_id': appointmentId,
      'status': status,
      'priority': priority,
      'is_present': isPresent,
      'entry_time': entryTime?.toIso8601String(),
      'called_time': calledTime?.toIso8601String(),
      'wait_minutes': waitMinutes,
    };
  }
}
