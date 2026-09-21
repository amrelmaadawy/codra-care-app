import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/use_cases/complete_examination_use_case.dart';
import '../../domain/use_cases/copy_previous_visit_use_case.dart';
import '../../domain/use_cases/delete_file_use_case.dart';
import '../../domain/use_cases/get_examination_use_case.dart';
import '../../domain/use_cases/save_section_use_case.dart';
import '../../domain/use_cases/upload_files_use_case.dart';
import 'examination_cubit_helpers.dart';
import 'examination_state.dart';

class ExaminationCubit extends Cubit<ExaminationState> {
  final int visitId;
  final GetExaminationUseCase getExaminationUseCase;
  final SaveSectionUseCase saveSectionUseCase;
  final UploadFilesUseCase uploadFilesUseCase;
  final DeleteFileUseCase deleteFileUseCase;
  final CompleteExaminationUseCase completeExaminationUseCase;
  final CopyPreviousVisitUseCase copyPreviousVisitUseCase;

  Timer? _debounceTimer;

  ExaminationCubit({
    required this.visitId,
    required this.getExaminationUseCase,
    required this.saveSectionUseCase,
    required this.uploadFilesUseCase,
    required this.deleteFileUseCase,
    required this.completeExaminationUseCase,
    required this.copyPreviousVisitUseCase,
  }) : super(const ExaminationInitial());

  Future<void> loadExamination() async {
    emit(const ExaminationLoading());
    final result = await getExaminationUseCase(visitId);
    result.fold(
      (failure) => emit(ExaminationError(mapFailure(failure))),
      (entity) => emit(ExaminationLoaded(visit: entity)),
    );
  }

  void autoSaveSection(String section, Map<String, dynamic> data) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      forceSaveSection(section, data);
    });
  }

  Future<void> forceSaveSection(String section, Map<String, dynamic> data) async {
    final current = state;
    if (current is! ExaminationLoaded) return;

    final updated = applySectionData(current.visit, section, data);
    final saving = Set<String>.from(current.savingSections)..add(section);
    final saved = Set<String>.from(current.savedSections)..remove(section);
    emit(current.copyWith(
      visit: updated,
      savingSections: saving,
      savedSections: saved,
      clearErrors: true,
    ));

    final result = await saveSectionUseCase(
      visitId: visitId,
      section: section,
      data: data,
    );
    if (isClosed) return;
    final after = state;
    if (after is! ExaminationLoaded) return;

    result.fold(
      (failure) {
        final newSaving = Set<String>.from(after.savingSections)..remove(section);
        emit(after.copyWith(
          savingSections: newSaving,
          errorMessage: mapFailure(failure),
        ));
      },
      (_) {
        final newSaving = Set<String>.from(after.savingSections)..remove(section);
        final newSaved = Set<String>.from(after.savedSections)..add(section);
        emit(after.copyWith(savingSections: newSaving, savedSections: newSaved));
      },
    );
  }

  Future<void> uploadFiles(List<String> paths, String type, String? desc) async {
    final current = state;
    if (current is! ExaminationLoaded) return;

    emit(current.copyWith(isUploading: true, clearErrors: true));
    final result = await uploadFilesUseCase(
      visitId: visitId,
      filePaths: paths,
      type: type,
      description: desc,
    );

    if (isClosed) return;
    final after = state;
    if (after is! ExaminationLoaded) return;

    result.fold(
      (failure) => emit(after.copyWith(isUploading: false, errorMessage: mapFailure(failure))),
      (newImages) => emit(after.copyWith(
        isUploading: false,
        visit: after.visit.copyWith(images: [...after.visit.images, ...newImages]),
        successMessage: 'examination.upload_success',
      )),
    );
  }

  Future<void> deleteFile(int imageId) async {
    final current = state;
    if (current is! ExaminationLoaded) return;

    final result = await deleteFileUseCase(visitId: visitId, imageId: imageId);
    if (isClosed) return;
    final after = state;
    if (after is! ExaminationLoaded) return;

    result.fold(
      (failure) => emit(after.copyWith(errorMessage: mapFailure(failure))),
      (_) {
        final updated = after.visit.images.where((i) => i.id != imageId).toList();
        emit(after.copyWith(visit: after.visit.copyWith(images: updated)));
      },
    );
  }

  Future<void> completeExamination(Map<String, dynamic> data) async {
    final current = state;
    if (current is! ExaminationLoaded) return;

    final complaint = (data['chief_complaint'] as String?)?.trim() ?? '';
    final diagnosis = (data['diagnosis'] as String?)?.trim() ?? '';

    if (complaint.isEmpty) {
      emit(current.copyWith(errorMessage: 'examination.validation_complaint_required'));
      return;
    }
    if (diagnosis.isEmpty) {
      emit(current.copyWith(errorMessage: 'examination.validation_diagnosis_required'));
      return;
    }

    emit(current.copyWith(isCompleting: true, clearErrors: true));
    final result = await completeExaminationUseCase(visitId: visitId, data: data);

    if (isClosed) return;
    final after = state;
    if (after is! ExaminationLoaded) return;

    result.fold(
      (failure) => emit(after.copyWith(
        isCompleting: false,
        errorMessage: mapFailure(failure),
        fieldErrors: failure is ValidationFailure ? failure.fieldErrors : null,
      )),
      (_) => emit(after.copyWith(isCompleting: false, isCompleted: true)),
    );
  }

  Future<void> copyPreviousVisit(int prevId) async {
    final current = state;
    if (current is! ExaminationLoaded) return;

    final result = await copyPreviousVisitUseCase(visitId: visitId, prevId: prevId);
    if (isClosed) return;
    final after = state;
    if (after is! ExaminationLoaded) return;

    result.fold(
      (failure) => emit(after.copyWith(errorMessage: mapFailure(failure))),
      (data) => emit(after.copyWith(
        visit: after.visit.copyWith(
          chiefComplaint: data['chief_complaint'] as String?,
          diagnosis: data['diagnosis'] as String?,
          notes: data['notes'] as String?,
        ),
        successMessage: 'examination.copied_success',
      )),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
