import '../../domain/entities/visit_patient_entity.dart';

class VisitPatientModel extends VisitPatientEntity {
  const VisitPatientModel({
    required super.id,
    required super.name,
    super.code,
    super.phone,
    super.gender,
    super.age,
    super.bloodType,
  });

  factory VisitPatientModel.fromJson(Map<String, dynamic> json) {
    int? parsedAge;
    if (json['age'] != null) {
      parsedAge = int.tryParse(json['age'].toString());
    }

    final rawName = json['name'] as String?;
    final resolvedName = (rawName != null && rawName.trim().isNotEmpty)
        ? rawName
        : (json['full_name'] as String? ?? '');

    return VisitPatientModel(
      id: json['id'] as int,
      name: resolvedName,
      code: json['code'] as String? ?? json['patient_code'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      age: parsedAge,
      bloodType: json['blood_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'phone': phone,
      'gender': gender,
      'age': age,
      'blood_type': bloodType,
    };
  }
}
