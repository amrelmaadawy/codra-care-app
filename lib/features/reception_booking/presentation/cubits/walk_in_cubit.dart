// ignore_for_file: prefer_initializing_formals
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_patient_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/usecases/create_walk_in_use_case.dart';
import '../../domain/usecases/get_booking_form_context_use_case.dart';
import '../../domain/usecases/search_patients_use_case.dart';
import 'walk_in_state.dart';

class WalkInCubit extends Cubit<WalkInState> {
  final GetBookingFormContextUseCase _getContextUseCase;
  final SearchPatientsUseCase _searchPatientsUseCase;
  final CreateWalkInUseCase _createWalkInUseCase;
  Timer? _searchDebounce;

  WalkInCubit({
    required GetBookingFormContextUseCase getContextUseCase,
    required SearchPatientsUseCase searchPatientsUseCase,
    required CreateWalkInUseCase createWalkInUseCase,
  }) : _getContextUseCase = getContextUseCase,
       _searchPatientsUseCase = searchPatientsUseCase,
       _createWalkInUseCase = createWalkInUseCase,
       super(WalkInState(clientRequestId: UuidGenerator.generate()));

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> init() async {
    emit(state.copyWith(isLoadingContext: true, clearError: true));
    final res = await _getContextUseCase();
    res.fold(
      (f) => emit(state.copyWith(isLoadingContext: false, contextError: f.message)),
      (ctx) => emit(state.copyWith(isLoadingContext: false, formContext: ctx)),
    );
  }

  void searchPatients(String query) {
    _searchDebounce?.cancel();
    if (query.trim().isEmpty) {
      emit(state.copyWith(searchResults: const [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));
    _searchDebounce = Timer(const Duration(milliseconds: 350), () async {
      final res = await _searchPatientsUseCase(query.trim());
      res.fold(
        (f) => emit(state.copyWith(isSearching: false)),
        (list) => emit(state.copyWith(isSearching: false, searchResults: list)),
      );
    });
  }

  void selectPatient(BookingPatientEntity patient) =>
      emit(state.copyWith(selectedPatient: patient, isNewPatient: false));

  void setNewPatient(NewPatientParams params) =>
      emit(state.copyWith(newPatient: params, isNewPatient: true));

  void toggleNewPatient(bool isNew) =>
      emit(state.copyWith(isNewPatient: isNew));

  Future<void> selectDoctor(BookingDoctorEntity doctor) async {
    emit(state.copyWith(selectedDoctor: doctor, isLoadingContext: true));
    final res = await _getContextUseCase(doctorId: doctor.id);
    res.fold(
      (f) => emit(state.copyWith(isLoadingContext: false, contextError: f.message)),
      (ctx) {
        final defId = doctor.defaultServiceId;
        final auto = defId == null
            ? null
            : ctx.services.where((s) => s.id == defId).firstOrNull;
        emit(state.copyWith(
          isLoadingContext: false,
          formContext: ctx,
          selectedService: auto ?? state.selectedService,
        ));
      },
    );
  }

  void selectService(BookingServiceEntity srv) =>
      emit(state.copyWith(selectedService: srv));

  void selectPriority(String priority) =>
      emit(state.copyWith(selectedPriority: priority));

  void setQuestionAnswer(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(state.questionAnswers);
    updated[key] = value;
    emit(state.copyWith(questionAnswers: updated));
  }

  void setVitalSign(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(state.vitalSigns);
    if (value == null || (value is String && value.trim().isEmpty)) {
      updated.remove(key);
    } else {
      updated[key] = value;
    }
    emit(state.copyWith(vitalSigns: updated));
  }

  void setNotes(String notes) => emit(state.copyWith(notes: notes));

  void nextStage() {
    if (state.stage == 1 && !state.isStage1Valid) return;
    if (state.stage == 2 && !state.isStage2Valid) return;
    if (state.stage < 3) emit(state.copyWith(stage: state.stage + 1));
  }

  void prevStage() {
    if (state.stage > 1) emit(state.copyWith(stage: state.stage - 1));
  }

  void goToStage(int target) {
    if (target < 1 || target > 3) return;
    if (target > state.stage) {
      if (state.stage == 1 && !state.isStage1Valid) return;
      if (state.stage == 2 && !state.isStage2Valid) return;
    }
    emit(state.copyWith(stage: target));
  }

  Future<void> submit() async {
    final params = state.toWalkInParams();
    if (state.isSubmitting || params == null) return;
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));
    final res = await _createWalkInUseCase(params);
    res.fold(
      (f) => emit(state.copyWith(isSubmitting: false, submitError: f.message)),
      (result) => emit(state.copyWith(
        isSubmitting: false,
        submitSuccess: true,
        walkInResult: result,
      )),
    );
  }

  void reset() {
    emit(WalkInState(clientRequestId: UuidGenerator.generate()));
  }
}
