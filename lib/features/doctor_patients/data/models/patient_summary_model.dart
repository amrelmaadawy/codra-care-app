import '../../domain/entities/patient_summary_entity.dart';

class PatientSummaryModel extends PatientSummaryEntity {
  const PatientSummaryModel({
    required super.id,
    required super.name,
    required super.code,
    super.phone,
    super.gender,
    super.genderLabel,
    super.age,
    required super.totalVisits,
    super.lastVisitDate,
    super.lastVisitDateHuman,
  });

  factory PatientSummaryModel.fromJson(Map<String, dynamic> json) {
    return PatientSummaryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      code: (json['code'] as String?) ?? '',
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      genderLabel: json['gender_label'] as String?,
      age: (json['age'] as num?)?.toInt(),
      totalVisits: (json['total_visits'] as num?)?.toInt() ?? 0,
      lastVisitDate: json['last_visit_date'] as String?,
      lastVisitDateHuman: json['last_visit_date_human'] as String?,
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
      'total_visits': totalVisits,
      'last_visit_date': lastVisitDate,
      'last_visit_date_human': lastVisitDateHuman,
    };
  }
}
