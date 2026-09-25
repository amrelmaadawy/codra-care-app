import '../../domain/entities/appointment_patient_entity.dart';

class AppointmentPatientModel extends AppointmentPatientEntity {
  const AppointmentPatientModel({
    required super.id,
    super.patientCode,
    required super.fullName,
    super.phone,
    super.gender,
    super.age,
  });

  factory AppointmentPatientModel.fromJson(Map<String, dynamic> json) {
    return AppointmentPatientModel(
      id: (json['id'] as num).toInt(),
      patientCode: json['patient_code'] as String?,
      fullName: (json['full_name'] as String?) ?? '',
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      age: (json['age'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_code': patientCode,
      'full_name': fullName,
      'phone': phone,
      'gender': gender,
      'age': age,
    };
  }
}
