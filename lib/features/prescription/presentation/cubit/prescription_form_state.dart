import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_context_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/entities/prescription_patient_entity.dart';
import 'drug_item_draft.dart';

sealed class PrescriptionFormState extends Equatable {
  const PrescriptionFormState();

  @override
  List<Object?> get props => [];
}

class PrescriptionFormInitial extends PrescriptionFormState {
  const PrescriptionFormInitial();
}

class PrescriptionFormLoading extends PrescriptionFormState {
  const PrescriptionFormLoading();
}

class PrescriptionFormReady extends PrescriptionFormState {
  final List<DrugItemDraft> items;
  final PrescriptionPatientEntity? selectedPatient;
  final int? visitId;
  final String? visitNumber;
  final String notes;
  final bool isEditing;
  final int? prescriptionId;
  final bool isSubmitting;
  final PrescriptionContextEntity contextData;

  const PrescriptionFormReady({
    required this.items,
    this.selectedPatient,
    this.visitId,
    this.visitNumber,
    this.notes = '',
    this.isEditing = false,
    this.prescriptionId,
    this.isSubmitting = false,
    required this.contextData,
  });

  bool get canSubmit =>
      selectedPatient != null &&
      items.isNotEmpty &&
      items.any((item) => item.isValid);

  PrescriptionFormReady copyWith({
    List<DrugItemDraft>? items,
    PrescriptionPatientEntity? selectedPatient,
    int? visitId,
    String? visitNumber,
    String? notes,
    bool? isEditing,
    int? prescriptionId,
    bool? isSubmitting,
    PrescriptionContextEntity? contextData,
  }) {
    return PrescriptionFormReady(
      items: items ?? this.items,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      visitId: visitId ?? this.visitId,
      visitNumber: visitNumber ?? this.visitNumber,
      notes: notes ?? this.notes,
      isEditing: isEditing ?? this.isEditing,
      prescriptionId: prescriptionId ?? this.prescriptionId,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      contextData: contextData ?? this.contextData,
    );
  }

  @override
  List<Object?> get props => [
        items,
        selectedPatient,
        visitId,
        visitNumber,
        notes,
        isEditing,
        prescriptionId,
        isSubmitting,
        contextData,
      ];
}

class PrescriptionFormSuccess extends PrescriptionFormState {
  final PrescriptionEntity prescription;
  final bool isEditing;

  const PrescriptionFormSuccess({
    required this.prescription,
    required this.isEditing,
  });

  @override
  List<Object?> get props => [prescription, isEditing];
}

class PrescriptionFormError extends PrescriptionFormState {
  final String message;

  const PrescriptionFormError(this.message);

  @override
  List<Object?> get props => [message];
}
