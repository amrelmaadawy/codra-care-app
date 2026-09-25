import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_appointment_result_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_doctor_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_form_context_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_patient_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_service_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_slot_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_types_and_capabilities.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/create_appointment_params.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/create_appointment_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/get_booking_form_context_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/search_patients_use_case.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/appointment_form_cubit.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/appointment_form_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookingFormContextUseCase extends Mock
    implements GetBookingFormContextUseCase {}

class MockSearchPatientsUseCase extends Mock implements SearchPatientsUseCase {}

class MockCreateAppointmentUseCase extends Mock
    implements CreateAppointmentUseCase {}

void main() {
  late AppointmentFormCubit cubit;
  late MockGetBookingFormContextUseCase mockGetContext;
  late MockSearchPatientsUseCase mockSearch;
  late MockCreateAppointmentUseCase mockCreate;

  setUpAll(() {
    registerFallbackValue(
      const CreateAppointmentParams(
        doctorId: 1,
        serviceId: 1,
        appointmentDate: '2026-09-25',
        bookingType: 'first_visit',
      ),
    );
  });

  setUp(() {
    mockGetContext = MockGetBookingFormContextUseCase();
    mockSearch = MockSearchPatientsUseCase();
    mockCreate = MockCreateAppointmentUseCase();

    cubit = AppointmentFormCubit(
      getContextUseCase: mockGetContext,
      searchPatientsUseCase: mockSearch,
      createAppointmentUseCase: mockCreate,
    );
  });

  tearDown(() => cubit.close());

  const tDoctor = BookingDoctorEntity(
    id: 1,
    name: 'Dr. John',
    specialization: 'General',
    scheduleMode: 'timed',
    requiresTime: true,
  );
  const tService = BookingServiceEntity(
    id: 2,
    name: 'Consultation',
    price: 100.0,
    durationMinutes: 15,
    isPackage: false,
  );
  const tContext = BookingFormContextEntity(
    serverDate: '2026-09-25',
    serverTime: '10:00:00',
    doctors: [tDoctor],
    services: [tService],
    questions: [],
    bookingTypes: [
      BookingTypeEntity(value: 'first_visit', label: 'First Visit'),
    ],
    capabilities: BookingCapabilitiesEntity(
      canCreatePatient: true,
      canViewQuestions: true,
      canAnswerQuestions: true,
    ),
  );

  test('initial state should have stage 1 and empty selections', () {
    expect(cubit.state.stage, 1);
    expect(cubit.state.isNewPatient, false);
    expect(cubit.state.selectedDoctor, isNull);
  });

  blocTest<AppointmentFormCubit, AppointmentFormState>(
    'init loads form context and sets selectedDate',
    build: () {
      when(
        () => mockGetContext(date: any(named: 'date')),
      ).thenAnswer((_) async => const Right(tContext));
      return cubit;
    },
    act: (cubit) => cubit.init(initialDate: '2026-09-25'),
    expect: () => [
      const AppointmentFormState(isLoadingContext: true),
      isA<AppointmentFormState>()
          .having((s) => s.isLoadingContext, 'isLoadingContext', false)
          .having((s) => s.selectedDate, 'selectedDate', '2026-09-25')
          .having((s) => s.formContext, 'formContext', tContext),
    ],
  );

  blocTest<AppointmentFormCubit, AppointmentFormState>(
    'stage progression respects validation guards',
    build: () => cubit,
    act: (cubit) {
      cubit.nextStage(); // should not advance because stage 1 not valid
      cubit.selectPatient(
        const BookingPatientEntity(
          id: 1,
          fullName: 'Ahmed',
          phone: '01000000000',
        ),
      );
      cubit.nextStage(); // now valid -> stage 2
    },
    expect: () => [
      isA<AppointmentFormState>().having((s) => s.selectedPatient?.id, 'id', 1),
      isA<AppointmentFormState>().having((s) => s.stage, 'stage', 2),
    ],
  );

  blocTest<AppointmentFormCubit, AppointmentFormState>(
    'submit creates appointment and sets submitSuccess',
    build: () {
      when(() => mockCreate(any())).thenAnswer(
        (_) async => const Right(
          BookingAppointmentResultEntity(
            id: 99,
            status: 'scheduled',
            date: '2026-09-25',
            patientName: 'Ahmed',
            doctorName: 'Dr. John',
            serviceName: 'Consultation',
          ),
        ),
      );
      return cubit;
    },
    seed: () => const AppointmentFormState(
      stage: 3,
      selectedPatient: BookingPatientEntity(
        id: 1,
        fullName: 'Ahmed',
        phone: '01000000000',
      ),
      selectedDoctor: tDoctor,
      selectedService: tService,
      selectedDate: '2026-09-25',
      selectedSlot: BookingSlotEntity(
        value: '10:00:00',
        label: '10:00',
        end: '10:15:00',
        isBooked: false,
      ),
    ),
    act: (cubit) => cubit.submit(),
    expect: () => [
      isA<AppointmentFormState>().having(
        (s) => s.isSubmitting,
        'isSubmitting',
        true,
      ),
      isA<AppointmentFormState>()
          .having((s) => s.isSubmitting, 'isSubmitting', false)
          .having((s) => s.submitSuccess, 'submitSuccess', true)
          .having((s) => s.createdAppointment?.id, 'id', 99),
    ],
  );
}
