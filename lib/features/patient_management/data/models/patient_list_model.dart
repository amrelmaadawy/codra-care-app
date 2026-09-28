import '../../domain/entities/patient_list_entity.dart';

class PatientListModel extends PatientListEntity {
  const PatientListModel({
    required super.id,
    required super.code,
    required super.name,
    super.phone,
    super.gender,
    super.age,
    super.lastVisitDate,
  });

  factory PatientListModel.fromJson(Map<String, dynamic> json) {
    final rawGender = json['gender']?.toString().toLowerCase().trim();
    final parsedGender = (rawGender == 'male' || rawGender == 'female')
        ? rawGender
        : null;

    final rawAge = json['age'];
    final parsedAge = rawAge is num ? rawAge.toInt() : null;

    return PatientListModel(
      id: (json['id'] as num).toInt(),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString().trim().isEmpty ?? true
          ? null
          : json['phone']?.toString().trim(),
      gender: parsedGender,
      age: parsedAge,
      lastVisitDate: json['last_visit_date']?.toString().trim().isEmpty ?? true
          ? null
          : json['last_visit_date']?.toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'phone': phone,
      'gender': gender,
      'age': age,
      'last_visit_date': lastVisitDate,
    };
  }
}
