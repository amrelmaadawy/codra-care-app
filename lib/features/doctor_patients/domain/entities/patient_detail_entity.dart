import 'package:equatable/equatable.dart';
import 'patient_medical_history_entity.dart';
import 'patient_profile_info_entity.dart';
import 'patient_stats_entity.dart';
import 'patient_visit_entity.dart';

class PatientDetailEntity extends Equatable {
  final PatientProfileInfoEntity patient;
  final PatientStatsEntity stats;
  final List<PatientVisitEntity> visits;
  final PatientMedicalHistoryEntity? medicalHistory;

  const PatientDetailEntity({
    required this.patient,
    required this.stats,
    required this.visits,
    this.medicalHistory,
  });

  @override
  List<Object?> get props => [
    patient,
    stats,
    visits,
    medicalHistory,
  ];
}
