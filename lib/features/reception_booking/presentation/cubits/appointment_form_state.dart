import 'package:equatable/equatable.dart';
import '../../domain/entities/booking_appointment_result_entity.dart';
import '../../domain/entities/booking_doctor_entity.dart';
import '../../domain/entities/booking_form_context_entity.dart';
import '../../domain/entities/booking_patient_entity.dart';
import '../../domain/entities/booking_service_entity.dart';
import '../../domain/entities/booking_slot_entity.dart';
import '../../domain/entities/create_appointment_params.dart';

class AppointmentFormState extends Equatable {
  final int stage; // 1, 2, 3
  final BookingFormContextEntity? formContext;
  final bool isLoadingContext;
  final String? contextError;

  // Stage 1: Patient
  final bool isNewPatient;
  final BookingPatientEntity? selectedPatient;
  final NewPatientParams? newPatient;
  final List<BookingPatientEntity> searchResults;
  final bool isSearching;

  // Stage 2: Schedule
  final BookingDoctorEntity? selectedDoctor;
  final BookingServiceEntity? selectedService;
  final String? selectedDate;
  final BookingSlotEntity? selectedSlot;
  final String selectedBookingType;
  final bool isLoadingSlots;

  // Stage 3: Review & Questions
  final Map<String, dynamic> questionAnswers;
  final String? notes;

  // Submission
  final bool isSubmitting;
  final bool submitSuccess;
  final BookingAppointmentResultEntity? createdAppointment;
  final String? submitError;

  const AppointmentFormState({
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
    this.selectedDate,
    this.selectedSlot,
    this.selectedBookingType = 'first_visit',
    this.isLoadingSlots = false,
    this.questionAnswers = const {},
    this.notes,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.createdAppointment,
    this.submitError,
  });

  bool get isStage1Valid =>
      (isNewPatient && newPatient != null) ||
      (!isNewPatient && selectedPatient != null);

  bool get isStage2Valid {
    if (selectedDoctor == null ||
        selectedService == null ||
        selectedDate == null) {
      return false;
    }
    if (selectedDoctor!.isTimed && selectedSlot == null) {
      return false;
    }
    return true;
  }

  AppointmentFormState copyWith({
    int? stage,
    BookingFormContextEntity? formContext,
    bool? isLoadingContext,
    String? contextError,
    bool clearError = false,
    bool? isNewPatient,
    BookingPatientEntity? selectedPatient,
    bool clearSelectedPatient = false,
    NewPatientParams? newPatient,
    bool clearNewPatient = false,
    List<BookingPatientEntity>? searchResults,
    bool? isSearching,
    BookingDoctorEntity? selectedDoctor,
    bool clearDoctor = false,
    BookingServiceEntity? selectedService,
    bool clearService = false,
    String? selectedDate,
    BookingSlotEntity? selectedSlot,
    bool clearSlot = false,
    String? selectedBookingType,
    bool? isLoadingSlots,
    Map<String, dynamic>? questionAnswers,
    String? notes,
    bool? isSubmitting,
    bool? submitSuccess,
    BookingAppointmentResultEntity? createdAppointment,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return AppointmentFormState(
      stage: stage ?? this.stage,
      formContext: formContext ?? this.formContext,
      isLoadingContext: isLoadingContext ?? this.isLoadingContext,
      contextError: clearError ? null : (contextError ?? this.contextError),
      isNewPatient: isNewPatient ?? this.isNewPatient,
      selectedPatient: clearSelectedPatient
          ? null
          : (selectedPatient ?? this.selectedPatient),
      newPatient: clearNewPatient ? null : (newPatient ?? this.newPatient),
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      selectedDoctor: clearDoctor
          ? null
          : (selectedDoctor ?? this.selectedDoctor),
      selectedService: clearService
          ? null
          : (selectedService ?? this.selectedService),
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlot: clearSlot ? null : (selectedSlot ?? this.selectedSlot),
      selectedBookingType: selectedBookingType ?? this.selectedBookingType,
      isLoadingSlots: isLoadingSlots ?? this.isLoadingSlots,
      questionAnswers: questionAnswers ?? this.questionAnswers,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      createdAppointment: createdAppointment ?? this.createdAppointment,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }

  CreateAppointmentParams? toCreateParams() {
    if (!isStage1Valid || !isStage2Valid) return null;
    return CreateAppointmentParams(
      doctorId: selectedDoctor!.id,
      serviceId: selectedService!.id,
      appointmentDate: selectedDate!,
      appointmentTime: selectedSlot?.value,
      bookingType: selectedBookingType,
      patientId: isNewPatient ? null : selectedPatient?.id,
      newPatient: isNewPatient ? newPatient : null,
      notes: notes,
      questionAnswers: questionAnswers,
    );
  }

  @override
  List<Object?> get props => [
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
    selectedDate,
    selectedSlot,
    selectedBookingType,
    isLoadingSlots,
    questionAnswers,
    notes,
    isSubmitting,
    submitSuccess,
    createdAppointment,
    submitError,
  ];
}
