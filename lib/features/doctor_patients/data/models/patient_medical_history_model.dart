import '../../domain/entities/patient_medical_history_entity.dart';

class PatientMedicalHistoryModel extends PatientMedicalHistoryEntity {
  const PatientMedicalHistoryModel({
    super.chronicDiseases,
    super.allergies,
    super.previousSurgeries,
    super.familyHistory,
    super.regularMedications,
    super.specialConditions,
  });

  factory PatientMedicalHistoryModel.fromJson(Map<String, dynamic> json) {
    return PatientMedicalHistoryModel(
      chronicDiseases: json['chronic_diseases'] as String?,
      allergies: json['allergies'] as String?,
      previousSurgeries: json['previous_surgeries'] as String?,
      familyHistory: json['family_history'] as String?,
      regularMedications: json['regular_medications'] as String?,
      specialConditions: json['special_conditions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chronic_diseases': chronicDiseases,
      'allergies': allergies,
      'previous_surgeries': previousSurgeries,
      'family_history': familyHistory,
      'regular_medications': regularMedications,
      'special_conditions': specialConditions,
    };
  }
}
