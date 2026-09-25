import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_form_context_entity.dart';
import '../../domain/entities/booking_patient_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import '../../domain/entities/create_appointment_params.dart';
import '../../domain/entities/walk_in_params.dart';
import '../../domain/entities/walk_in_result_entity.dart';

class WalkInState extends Equatable {
  final String clientRequestId;
  final int stage;
  final BookingFormContextEntity? formContext;
  final bool isLoadingContext;
  final String? contextError;

  // Stage 1
  final bool isNewPatient;
  final BookingPatientEntity? selectedPatient;
  final NewPatientParams? newPatient;
  final List<BookingPatientEntity> searchResults;
  final bool isSearching;

  // Stage 2
  final BookingDoctorEntity? selectedDoctor;
  final BookingServiceEntity? selectedService;
  final String selectedBookingType;
  final String selectedPriority;

  // Stage 3
  final Map<String, dynamic> questionAnswers;
  final Map<String, dynamic> vitalSigns;
  final String? notes;

  // Submission
  final bool isSubmitting;
  final bool submitSuccess;
  final WalkInResultEntity? walkInResult;
  final String? submitError;

  const WalkInState({
    required this.clientRequestId,
    this.stage = 1,
    this.formContext,
    this.isLoadingContext = false,
    this.contextError,
    this.isNewPatient = false,
    this.selectedPatient,
    this.newPatient,
    this.searchResults = const [],
    this.isSearching = false,
    this.selectedDoctor,
    this.selectedService,
    this.selectedBookingType = 'first_visit',
    this.selectedPriority = 'normal',
    this.questionAnswers = const {},
    this.vitalSigns = const {},
    this.notes,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.walkInResult,
    this.submitError,
  });

  bool get isStage1Valid =>
      (isNewPatient &&
          newPatient != null &&
          newPatient!.fullName.trim().isNotEmpty &&
          newPatient!.phone.trim().isNotEmpty) ||
      (!isNewPatient && selectedPatient != null);

  bool get isStage2Valid => selectedDoctor != null && selectedService != null;

  bool get isStage3Valid {
    if (formContext == null || formContext!.questions.isEmpty) return true;
    for (final q in formContext!.questions) {
      if (q.required) {
        final val = questionAnswers[q.index.toString()];
        if (val == null || (val is String && val.trim().isEmpty)) return false;
        if (val is List && val.isEmpty) return false;
      }
    }
    return true;
  }

  WalkInParams? toWalkInParams() {
    if (!isStage1Valid || !isStage2Valid) return null;

    final List<dynamic> answersList = [];
    if (formContext != null && formContext!.questions.isNotEmpty) {
      for (final q in formContext!.questions) {
        final raw = questionAnswers[q.index.toString()];
        answersList.add(raw ?? '');
      }
    }

    return WalkInParams(
      clientRequestId: clientRequestId,
      patientId: isNewPatient ? null : selectedPatient?.id,
      newPatient: isNewPatient ? newPatient : null,
      doctorId: selectedDoctor!.id,
      serviceId: selectedService!.id,
      bookingType: selectedBookingType,
      priority: selectedPriority,
      notes: notes,
      answers: answersList.isNotEmpty ? answersList : null,
      vitalSigns: vitalSigns.isNotEmpty ? vitalSigns : null,
    );
  }

  WalkInState copyWith({
    String? clientRequestId,
    int? stage,
    BookingFormContextEntity? formContext,
    bool? isLoadingContext,
    String? contextError,
    bool clearError = false,
    bool? isNewPatient,
    BookingPatientEntity? selectedPatient,
    NewPatientParams? newPatient,
    List<BookingPatientEntity>? searchResults,
    bool? isSearching,
    BookingDoctorEntity? selectedDoctor,
    BookingServiceEntity? selectedService,
    String? selectedBookingType,
    String? selectedPriority,
    Map<String, dynamic>? questionAnswers,
    Map<String, dynamic>? vitalSigns,
    String? notes,
    bool? isSubmitting,
    bool? submitSuccess,
    WalkInResultEntity? walkInResult,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return WalkInState(
      clientRequestId: clientRequestId ?? this.clientRequestId,
      stage: stage ?? this.stage,
      formContext: formContext ?? this.formContext,
      isLoadingContext: isLoadingContext ?? this.isLoadingContext,
      contextError: clearError ? null : (contextError ?? this.contextError),
      isNewPatient: isNewPatient ?? this.isNewPatient,
      selectedPatient: selectedPatient ?? this.selectedPatient,
      newPatient: newPatient ?? this.newPatient,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedService: selectedService ?? this.selectedService,
      selectedBookingType: selectedBookingType ?? this.selectedBookingType,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      questionAnswers: questionAnswers ?? this.questionAnswers,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      walkInResult: walkInResult ?? this.walkInResult,
      submitError: clearSubmitError
          ? null
          : (submitError ?? this.submitError),
    );
  }

  @override
  List<Object?> get props => [
    clientRequestId,
    stage,
    formContext,
    isLoadingContext,
    contextError,
    isNewPatient,
    selectedPatient,
    newPatient,
    searchResults,
    isSearching,
    selectedDoctor,
    selectedService,
    selectedBookingType,
    selectedPriority,
    questionAnswers,
    vitalSigns,
    notes,
    isSubmitting,
    submitSuccess,
    walkInResult,
    submitError,
  ];
}
