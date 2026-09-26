import '../../domain/entities/reception_queue_item_entity.dart';
import 'queue_capabilities_model.dart';
import 'vital_signs_model.dart';

class ReceptionQueueItemModel extends ReceptionQueueItemEntity {
  const ReceptionQueueItemModel({
    required super.id,
    required super.ticketNumber,
    required super.patientId,
    required super.patientName,
    super.patientPhone,
    required super.doctorId,
    required super.doctorName,
    super.serviceId,
    super.serviceName,
    super.appointmentId,
    required super.status,
    required super.priority,
    required super.isPresent,
    super.vitalSigns,
    super.entryTime,
    super.calledTime,
    super.completedTime,
    required super.waitMinutes,
    required super.capabilities,
  });

  factory ReceptionQueueItemModel.fromJson(Map<String, dynamic> json) {
    final patientObj = json['patient'] as Map<String, dynamic>?;
    final doctorObj = json['doctor'] as Map<String, dynamic>?;
    final serviceObj = json['service'] as Map<String, dynamic>?;
    final vitalsObj = json['vital_signs'] as Map<String, dynamic>?;
    final capObj = json['capabilities'] as Map<String, dynamic>?;

    final patientId = (patientObj?['id'] ?? json['patient_id'] as num?)?.toInt() ?? 0;
    final patientName = (patientObj?['name'] ?? json['patient_name'] as String?) ?? '';
    final patientPhone = (patientObj?['phone'] ?? json['patient_phone'] as String?);

    final doctorId = (doctorObj?['id'] ?? json['doctor_id'] as num?)?.toInt() ?? 0;
    final doctorName = (doctorObj?['name'] ?? json['doctor_name'] as String?) ?? '';

    final serviceId = (serviceObj?['id'] ?? json['service_id'] as num?)?.toInt();
    final serviceName = (serviceObj?['name'] ?? json['service_name'] as String?);

    return ReceptionQueueItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ticketNumber: (json['ticket_number'] as String?) ?? '',
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorId: doctorId,
      doctorName: doctorName,
      serviceId: serviceId,
      serviceName: serviceName,
      appointmentId: (json['appointment_id'] as num?)?.toInt(),
      status: (json['status'] as String?) ?? 'waiting',
      priority: (json['priority'] as String?) ?? 'normal',
      isPresent: (json['is_present'] as bool?) ?? false,
      vitalSigns: vitalsObj != null ? VitalSignsModel.fromJson(vitalsObj) : null,
      entryTime: json['entry_time'] != null ? DateTime.tryParse(json['entry_time'] as String) : null,
      calledTime: json['called_time'] != null ? DateTime.tryParse(json['called_time'] as String) : null,
      completedTime: json['completed_time'] != null ? DateTime.tryParse(json['completed_time'] as String) : null,
      waitMinutes: (json['wait_minutes'] as num?)?.toInt() ?? 0,
      capabilities: QueueCapabilitiesModel.fromJson(capObj),
    );
  }
}
