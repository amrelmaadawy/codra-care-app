import 'package:equatable/equatable.dart';
import 'prescription_entity.dart';
import 'prescription_patient_entity.dart';

class PrescriptionContextEntity extends Equatable {
  final PrescriptionPatientEntity? patient;
  final int? visitId;
  final List<PrescriptionEntity> previousPrescriptions;
  final List<PrescriptionPatientEntity> patients;
  final Map<String, String> routeOptions;
  final List<String> quickDosages;
  final List<String> quickFrequencies;
  final List<String> quickDurations;
  final List<String> quickNotes;

  const PrescriptionContextEntity({
    this.patient,
    this.visitId,
    this.previousPrescriptions = const [],
    this.patients = const [],
    this.routeOptions = const {},
    this.quickDosages = const [],
    this.quickFrequencies = const [],
    this.quickDurations = const [],
    this.quickNotes = const [],
  });

  @override
  List<Object?> get props => [
        patient,
        visitId,
        previousPrescriptions,
        patients,
        routeOptions,
        quickDosages,
        quickFrequencies,
        quickDurations,
        quickNotes,
      ];
}
