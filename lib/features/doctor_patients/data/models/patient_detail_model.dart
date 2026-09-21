import '../../domain/entities/patient_detail_entity.dart';
import 'patient_medical_history_model.dart';
import 'patient_profile_info_model.dart';
import 'patient_stats_model.dart';
import 'patient_visit_model.dart';

class PatientDetailModel extends PatientDetailEntity {
  const PatientDetailModel({
    required super.patient,
    required super.stats,
    required super.visits,
    super.medicalHistory,
  });

  factory PatientDetailModel.fromJson(Map<String, dynamic> json) {
    final patientMap = json['patient'] as Map<String, dynamic>? ?? {};
    final statsMap = json['stats'] as Map<String, dynamic>? ?? {};
    final visitsList = json['visits'] as List<dynamic>? ?? [];
    final historyMap = json['medical_history'] as Map<String, dynamic>?;

    return PatientDetailModel(
      patient: PatientProfileInfoModel.fromJson(patientMap),
      stats: PatientStatsModel.fromJson(statsMap),
      visits: visitsList
          .map((v) => PatientVisitModel.fromJson(v as Map<String, dynamic>))
          .toList(),
      medicalHistory: historyMap != null
          ? PatientMedicalHistoryModel.fromJson(historyMap)
          : null,
    );
  }
}
