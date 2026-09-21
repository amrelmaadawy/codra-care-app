import '../../domain/entities/prescription_patient_entity.dart';

class PrescriptionPatientModel extends PrescriptionPatientEntity {
  const PrescriptionPatientModel({
    required super.id,
    required super.fullName,
    super.phone,
    super.patientCode,
  });

  factory PrescriptionPatientModel.fromJson(Map<String, dynamic> json) {
    final name = (json['full_name'] as String?) ??
        (json['first_name'] as String?) ??
        'مريض';
    return PrescriptionPatientModel(
      id: json['id'] as int? ?? 0,
      fullName: name,
      phone: json['phone'] as String?,
      patientCode: json['patient_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'patient_code': patientCode,
    };
  }
}
