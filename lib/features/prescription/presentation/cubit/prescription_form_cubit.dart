import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/entities/prescription_patient_entity.dart';
import '../../domain/use_cases/copy_prescription_use_case.dart';
import '../../domain/use_cases/create_prescription_use_case.dart';
import '../../domain/use_cases/get_prescription_context_use_case.dart';
import '../../domain/use_cases/get_prescription_detail_use_case.dart';
import '../../domain/use_cases/update_prescription_use_case.dart';
import 'drug_item_draft.dart';
import 'prescription_cubit_helpers.dart';
import 'prescription_form_state.dart';

class PrescriptionFormCubit extends Cubit<PrescriptionFormState> {
  final GetPrescriptionContextUseCase getPrescriptionContextUseCase;
  final GetPrescriptionDetailUseCase getPrescriptionDetailUseCase;
  final CreatePrescriptionUseCase createPrescriptionUseCase;
  final UpdatePrescriptionUseCase updatePrescriptionUseCase;
  final CopyPrescriptionUseCase copyPrescriptionUseCase;

  PrescriptionFormCubit({
    required this.getPrescriptionContextUseCase,
    required this.getPrescriptionDetailUseCase,
    required this.createPrescriptionUseCase,
    required this.updatePrescriptionUseCase,
    required this.copyPrescriptionUseCase,
  }) : super(const PrescriptionFormInitial());

  @override
  void emit(PrescriptionFormState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> initForm({int? visitId, int? patientId, int? prescriptionId}) async {
    emit(const PrescriptionFormLoading());

    final contextResult = await getPrescriptionContextUseCase(
      visitId: visitId,
      patientId: patientId,
    );

    if (isClosed) return;

    await contextResult.fold(
      (failure) async => emit(PrescriptionFormError(mapPrescriptionFailure(failure))),
      (contextData) async {
        if (prescriptionId != null) {
          final detailResult = await getPrescriptionDetailUseCase(prescriptionId);
          detailResult.fold(
            (failure) => emit(PrescriptionFormError(mapPrescriptionFailure(failure))),
            (prescription) {
              final draftItems = prescription.items.map(DrugItemDraft.fromEntity).toList();
              emit(PrescriptionFormReady(
                items: draftItems.isNotEmpty ? draftItems : [_createEmptyDraft()],
                selectedPatient: prescription.patient,
                visitId: prescription.visitId ?? visitId,
                visitNumber: prescription.visitNumber,
                notes: prescription.notes ?? '',
                isEditing: true,
                prescriptionId: prescriptionId,
                contextData: contextData,
              ));
            },
          );
        } else {
          emit(PrescriptionFormReady(
            items: [_createEmptyDraft()],
            selectedPatient: contextData.patient,
            visitId: visitId ?? contextData.visitId,
            contextData: contextData,
          ));
        }
      },
    );
  }

  void addDrugItem() {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    final updated = List<DrugItemDraft>.from(current.items)..add(_createEmptyDraft());
    emit(current.copyWith(items: updated));
  }

  void removeDrugItem(int index) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    if (current.items.length <= 1) return;
    final updated = List<DrugItemDraft>.from(current.items)..removeAt(index);
    emit(current.copyWith(items: updated));
  }

  void updateDrugItem(int index, DrugItemDraft updatedItem) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    if (index < 0 || index >= current.items.length) return;
    final list = List<DrugItemDraft>.from(current.items);
    list[index] = updatedItem;
    emit(current.copyWith(items: list));
  }

  void reorderDrugItems(int oldIndex, int newIndex) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    final list = List<DrugItemDraft>.from(current.items);
    final actualNewIndex = oldIndex < newIndex ? newIndex - 1 : newIndex;
    final item = list.removeAt(oldIndex);
    list.insert(actualNewIndex, item);
    emit(current.copyWith(items: list));
  }

  void updateNotes(String notes) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    emit(current.copyWith(notes: notes));
  }

  void selectPatient(PrescriptionPatientEntity patient) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    emit(current.copyWith(selectedPatient: patient));
  }

  void copyFromPrevious(PrescriptionEntity prev) {
    final current = state;
    if (current is! PrescriptionFormReady) return;
    final draftItems = prev.items.map(DrugItemDraft.fromEntity).toList();
    if (draftItems.isNotEmpty) {
      emit(current.copyWith(
        items: draftItems,
        notes: prev.notes != null && prev.notes!.isNotEmpty
            ? prev.notes
            : current.notes,
      ));
    }
  }

  Future<void> submit() async {
    final current = state;
    if (current is! PrescriptionFormReady || current.isSubmitting) return;

    if (current.selectedPatient == null) {
      emit(const PrescriptionFormError('prescription.validation_patient'));
      emit(current);
      return;
    }

    final validItems = current.items.where((i) => i.isValid).toList();
    if (validItems.isEmpty) {
      emit(const PrescriptionFormError('prescription.validation_min_items'));
      emit(current);
      return;
    }

    emit(current.copyWith(isSubmitting: true));

    final itemsPayload = validItems
        .asMap()
        .entries
        .map((e) => e.value.toMap(sortOrder: e.key))
        .toList();

    if (current.isEditing && current.prescriptionId != null) {
      final result = await updatePrescriptionUseCase(
        id: current.prescriptionId!,
        patientId: current.selectedPatient!.id,
        visitId: current.visitId,
        notes: current.notes.isNotEmpty ? current.notes : null,
        items: itemsPayload,
      );
      result.fold(
        (failure) {
          emit(PrescriptionFormError(mapPrescriptionFailure(failure)));
          emit(current.copyWith(isSubmitting: false));
        },
        (saved) => emit(PrescriptionFormSuccess(prescription: saved, isEditing: true)),
      );
    } else {
      final result = await createPrescriptionUseCase(
        patientId: current.selectedPatient!.id,
        visitId: current.visitId,
        notes: current.notes.isNotEmpty ? current.notes : null,
        items: itemsPayload,
      );
      result.fold(
        (failure) {
          emit(PrescriptionFormError(mapPrescriptionFailure(failure)));
          emit(current.copyWith(isSubmitting: false));
        },
        (saved) => emit(PrescriptionFormSuccess(prescription: saved, isEditing: false)),
      );
    }
  }

  DrugItemDraft _createEmptyDraft() {
    return DrugItemDraft(id: DateTime.now().microsecondsSinceEpoch.toString());
  }
}

