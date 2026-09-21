import '../../domain/entities/queue_patient_entity.dart';

class QueuePatientModel extends QueuePatientEntity {
  const QueuePatientModel({
    required super.id,
    required super.ticketNumber,
    super.patientId,
    required super.patientName,
    super.patientPhone,
    super.patientAge,
    super.patientGender,
    required super.serviceName,
    required super.priority,
    super.priorityLabel,
    required super.status,
    super.statusLabel,
    required super.isUrgent,
    required super.isVip,
    super.entryTime,
    super.entryTimeHuman,
    super.calledTime,
    super.vitalSigns,
    required super.hasIntakeVitals,
    super.appointmentId,
  });

  factory QueuePatientModel.fromJson(Map<String, dynamic> json) {
    return QueuePatientModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ticketNumber: (json['ticket_number'] as String?) ?? '',
      patientId: (json['patient_id'] as num?)?.toInt(),
      patientName: (json['patient_name'] as String?) ?? '',
      patientPhone: json['patient_phone'] as String?,
      patientAge: (json['patient_age'] as num?)?.toInt(),
      patientGender: json['patient_gender'] as String?,
      serviceName: (json['service_name'] as String?) ?? '',
      priority: (json['priority'] as String?) ?? 'normal',
      priorityLabel: json['priority_label'] as String?,
      status: (json['status'] as String?) ?? 'waiting',
      statusLabel: json['status_label'] as String?,
      isUrgent: json['is_urgent'] as bool? ?? false,
      isVip: json['is_vip'] as bool? ?? false,
      entryTime: json['entry_time'] as String?,
      entryTimeHuman: json['entry_time_human'] as String?,
      calledTime: json['called_time'] as String?,
      vitalSigns: json['vital_signs'] is Map<String, dynamic>
          ? json['vital_signs'] as Map<String, dynamic>
          : null,
      hasIntakeVitals: json['has_intake_vitals'] as bool? ?? false,
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'patient_id': patientId,
      'patient_name': patientName,
      'patient_phone': patientPhone,
      'patient_age': patientAge,
      'patient_gender': patientGender,
      'service_name': serviceName,
      'priority': priority,
      'priority_label': priorityLabel,
      'status': status,
      'status_label': statusLabel,
      'is_urgent': isUrgent,
      'is_vip': isVip,
      'entry_time': entryTime,
      'entry_time_human': entryTimeHuman,
      'called_time': calledTime,
      'vital_signs': vitalSigns,
      'has_intake_vitals': hasIntakeVitals,
      'appointment_id': appointmentId,
    };
  }
}
