import '../../domain/entities/appointment_doctor_entity.dart';

class AppointmentDoctorModel extends AppointmentDoctorEntity {
  const AppointmentDoctorModel({
    required super.id,
    required super.name,
    super.specialization,
  });

  factory AppointmentDoctorModel.fromJson(Map<String, dynamic> json) {
    return AppointmentDoctorModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      specialization: json['specialization'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'specialization': specialization};
  }
}
