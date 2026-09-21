import '../../domain/entities/patient_profile_info_entity.dart';

class PatientProfileInfoModel extends PatientProfileInfoEntity {
  const PatientProfileInfoModel({
    required super.id,
    required super.name,
    required super.code,
    super.phone,
    super.gender,
    super.genderLabel,
    super.age,
    super.bloodType,
    super.dateOfBirth,
    super.nationalId,
    super.address,
  });

  factory PatientProfileInfoModel.fromJson(Map<String, dynamic> json) {
    return PatientProfileInfoModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      code: (json['code'] as String?) ?? '',
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      genderLabel: json['gender_label'] as String?,
      age: (json['age'] as num?)?.toInt(),
      bloodType: json['blood_type'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      nationalId: json['national_id'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'gender': gender,
      'gender_label': genderLabel,
      'age': age,
      'blood_type': bloodType,
      'date_of_birth': dateOfBirth,
      'national_id': nationalId,
      'address': address,
    };
  }
}
