import '../../domain/entities/patient_visit_entity.dart';

class PatientVisitModel extends PatientVisitEntity {
  const PatientVisitModel({
    required super.id,
    super.visitNumber,
    super.visitDate,
    super.status,
    super.statusLabel,
    super.chiefComplaint,
    super.diagnosis,
    super.notes,
    super.serviceName,
    required super.prescriptionsCount,
  });

  factory PatientVisitModel.fromJson(Map<String, dynamic> json) {
    return PatientVisitModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      visitNumber: json['visit_number'] as String?,
      visitDate: json['visit_date'] as String?,
      status: json['status'] as String?,
      statusLabel: json['status_label'] as String?,
      chiefComplaint: json['chief_complaint'] as String?,
      diagnosis: json['diagnosis'] as String?,
      notes: json['notes'] as String?,
      serviceName: json['service_name'] as String?,
      prescriptionsCount: (json['prescriptions_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_number': visitNumber,
      'visit_date': visitDate,
      'status': status,
      'status_label': statusLabel,
      'chief_complaint': chiefComplaint,
      'diagnosis': diagnosis,
      'notes': notes,
      'service_name': serviceName,
      'prescriptions_count': prescriptionsCount,
    };
  }
}
