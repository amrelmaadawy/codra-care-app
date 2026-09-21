import '../../domain/entities/prescription_context_entity.dart';
import 'prescription_model.dart';
import 'prescription_patient_model.dart';

class PrescriptionContextModel extends PrescriptionContextEntity {
  const PrescriptionContextModel({
    super.patient,
    super.visitId,
    super.previousPrescriptions,
    super.patients,
    super.routeOptions,
    super.quickDosages,
    super.quickFrequencies,
    super.quickDurations,
    super.quickNotes,
  });

  factory PrescriptionContextModel.fromJson(Map<String, dynamic> json) {
    PrescriptionPatientModel? patient;
    if (json['patient'] is Map<String, dynamic>) {
      patient = PrescriptionPatientModel.fromJson(
        json['patient'] as Map<String, dynamic>,
      );
    }

    int? visitId;
    if (json['visit'] is Map<String, dynamic>) {
      visitId = (json['visit'] as Map<String, dynamic>)['id'] as int?;
    }

    final rawPrev = json['previousPrescriptions'] as List<dynamic>? ?? [];
    final previousPrescriptions = rawPrev
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionModel.fromJson)
        .toList();

    final rawPatients = json['patients'] as List<dynamic>? ?? [];
    final patients = rawPatients
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionPatientModel.fromJson)
        .toList();

    final rawRoutes = json['routeOptions'];
    final routeOptions = <String, String>{};
    if (rawRoutes is Map) {
      rawRoutes.forEach((key, value) {
        routeOptions[key.toString()] = value.toString();
      });
    }

    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    return PrescriptionContextModel(
      patient: patient,
      visitId: visitId,
      previousPrescriptions: previousPrescriptions,
      patients: patients,
      routeOptions: routeOptions,
      quickDosages: parseStringList(json['quickDosages']),
      quickFrequencies: parseStringList(json['quickFrequencies']),
      quickDurations: parseStringList(json['quickDurations']),
      quickNotes: parseStringList(json['quickNotes']),
    );
  }
}
