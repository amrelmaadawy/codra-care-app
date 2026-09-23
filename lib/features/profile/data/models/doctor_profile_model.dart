import '../../domain/entities/doctor_profile_entity.dart';

class DoctorProfileModel extends DoctorProfileEntity {
  const DoctorProfileModel({
    required super.id,
    super.userId,
    required super.name,
    super.specialization,
    super.title,
    super.phone,
    super.email,
    super.licenseNumber,
    super.photoUrl,
    super.clinicCode,
    super.isActive = true,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    return DoctorProfileModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse('${json['user_id'] ?? ''}'),
      name: json['name'] as String? ?? '',
      specialization: json['specialization'] as String?,
      title: json['title'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      licenseNumber: json['license_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      clinicCode: json['clinic_code'] as String?,
      isActive: json['is_active'] == true || json['is_active'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'specialization': specialization,
      'title': title,
      'phone': phone,
      'email': email,
      'license_number': licenseNumber,
      'photo_url': photoUrl,
      'clinic_code': clinicCode,
      'is_active': isActive,
    };
  }
}
