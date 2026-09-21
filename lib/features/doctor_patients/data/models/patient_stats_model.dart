import '../../domain/entities/patient_stats_entity.dart';

class PatientStatsModel extends PatientStatsEntity {
  const PatientStatsModel({
    required super.visitsCount,
    super.firstVisit,
    super.lastVisit,
    required super.prescriptionsCount,
  });

  factory PatientStatsModel.fromJson(Map<String, dynamic> json) {
    return PatientStatsModel(
      visitsCount: (json['visits_count'] as num?)?.toInt() ?? 0,
      firstVisit: json['first_visit'] as String?,
      lastVisit: json['last_visit'] as String?,
      prescriptionsCount: (json['prescriptions_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visits_count': visitsCount,
      'first_visit': firstVisit,
      'last_visit': lastVisit,
      'prescriptions_count': prescriptionsCount,
    };
  }
}
