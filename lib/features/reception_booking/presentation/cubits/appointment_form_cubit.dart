import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_patient_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import '../../domain/entities/booking_slot_entity.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/usecases/create_appointment_use_case.dart';
import '../../domain/usecases/get_booking_form_context_use_case.dart';
import '../../domain/usecases/search_patients_use_case.dart';
import 'appointment_form_state.dart';

class AppointmentFormCubit extends Cubit<AppointmentFormState> {
  final GetBookingFormContextUseCase _getContextUseCase;
  final SearchPatientsUseCase _searchPatientsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  Timer? _searchDebounce;

  AppointmentFormCubit({
    required this._getContextUseCase,
    required this._searchPatientsUseCase,
    required this._createAppointmentUseCase,
  }) : super(const AppointmentFormState());

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }

  Future<void> init({String? initialDate}) async {
    emit(state.copyWith(isLoadingContext: true, clearError: true));
    final res = await _getContextUseCase(date: initialDate);
    res.fold(
      (f) => emit(
        state.copyWith(isLoadingContext: false, contextError: f.message),
      ),
      (ctx) {
        final date = initialDate ?? ctx.serverDate;
        emit(
          state.copyWith(
            isLoadingContext: false,
            formContext: ctx,
            selectedDate: date,
          ),
        );
      },
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
    emit(
      state.copyWith(
        selectedDoctor: doctor,
        clearSlot: true,
        isLoadingSlots: true,
      ),
    );
    final res = await _getContextUseCase(
      doctorId: doctor.id,
      date: state.selectedDate,
    );
    res.fold(
      (f) =>
          emit(state.copyWith(isLoadingSlots: false, contextError: f.message)),
      (ctx) {
        final defId = doctor.defaultServiceId;
        final auto = defId == null
            ? null
            : ctx.services.where((s) => s.id == defId).firstOrNull;
        emit(
          state.copyWith(
            isLoadingSlots: false,
            formContext: ctx,
            selectedService: auto ?? state.selectedService,
          ),
        );
      },
    );
  }

  Future<void> selectDate(String date) async {
    emit(
      state.copyWith(
        selectedDate: date,
        clearSlot: true,
        isLoadingSlots: state.selectedDoctor != null,
      ),
    );
    if (state.selectedDoctor == null) return;
    final res = await _getContextUseCase(
      doctorId: state.selectedDoctor!.id,
      date: date,
    );
    res.fold(
      (f) =>
          emit(state.copyWith(isLoadingSlots: false, contextError: f.message)),
      (ctx) => emit(state.copyWith(isLoadingSlots: false, formContext: ctx)),
    );
  }

  void selectService(BookingServiceEntity srv) =>
      emit(state.copyWith(selectedService: srv));

  void selectSlot(BookingSlotEntity slot) =>
      emit(state.copyWith(selectedSlot: slot));

  void selectBookingType(String type) =>
      emit(state.copyWith(selectedBookingType: type));

  void setQuestionAnswer(String key, dynamic value) {
    final updated = Map<String, dynamic>.from(state.questionAnswers);
    updated[key] = value;
    emit(state.copyWith(questionAnswers: updated));
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
    final params = state.toCreateParams();
    if (state.isSubmitting || params == null) return;
    emit(state.copyWith(isSubmitting: true, clearSubmitError: true));
    final res = await _createAppointmentUseCase(params);
    res.fold(
      (f) => emit(state.copyWith(isSubmitting: false, submitError: f.message)),
      (appt) => emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccess: true,
          createdAppointment: appt,
        ),
      ),
    );
  }
}
