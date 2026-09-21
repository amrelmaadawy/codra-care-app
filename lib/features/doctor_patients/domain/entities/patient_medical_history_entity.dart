import 'package:equatable/equatable.dart';

class PatientMedicalHistoryEntity extends Equatable {
  final String? chronicDiseases;
  final String? allergies;
  final String? previousSurgeries;
  final String? familyHistory;
  final String? regularMedications;
  final String? specialConditions;

  const PatientMedicalHistoryEntity({
    this.chronicDiseases,
    this.allergies,
    this.previousSurgeries,
    this.familyHistory,
    this.regularMedications,
    this.specialConditions,
  });

  bool get isEmpty =>
      (chronicDiseases == null || chronicDiseases!.trim().isEmpty) &&
      (allergies == null || allergies!.trim().isEmpty) &&
      (previousSurgeries == null || previousSurgeries!.trim().isEmpty) &&
      (familyHistory == null || familyHistory!.trim().isEmpty) &&
      (regularMedications == null || regularMedications!.trim().isEmpty) &&
      (specialConditions == null || specialConditions!.trim().isEmpty);

  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
    chronicDiseases,
    allergies,
    previousSurgeries,
    familyHistory,
    regularMedications,
    specialConditions,
  ];
}
