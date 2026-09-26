import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_doctor_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_form_context_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_patient_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_service_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_types_and_capabilities.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/walk_in_params.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/walk_in_result_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/create_walk_in_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/get_booking_form_context_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/search_patients_use_case.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/walk_in_cubit.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/walk_in_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBookingFormContextUseCase extends Mock
    implements GetBookingFormContextUseCase {}

class MockSearchPatientsUseCase extends Mock implements SearchPatientsUseCase {}

class MockCreateWalkInUseCase extends Mock implements CreateWalkInUseCase {}

void main() {
  late WalkInCubit cubit;
  late MockGetBookingFormContextUseCase mockGetContext;
  late MockSearchPatientsUseCase mockSearch;
  late MockCreateWalkInUseCase mockCreateWalkIn;

  setUpAll(() {
    registerFallbackValue(
      const WalkInParams(
        clientRequestId: 'test-uuid',
        patientId: 1,
        doctorId: 1,
        serviceId: 1,
      ),
    );
  });

  setUp(() {
    mockGetContext = MockGetBookingFormContextUseCase();
    mockSearch = MockSearchPatientsUseCase();
    mockCreateWalkIn = MockCreateWalkInUseCase();

    cubit = WalkInCubit(
      getContextUseCase: mockGetContext,
      searchPatientsUseCase: mockSearch,
      createWalkInUseCase: mockCreateWalkIn,
    );
  });

  tearDown(() => cubit.close());

  const tDoctor = BookingDoctorEntity(
    id: 1,
    name: 'Dr. John',
    specialization: 'General',
    scheduleMode: 'queue',
    requiresTime: false,
  );

  const tService = BookingServiceEntity(
    id: 1,
    name: 'General Consultation',
    price: 200,
    durationMinutes: 15,
    isPackage: false,
  );

  const tPatient = BookingPatientEntity(
    id: 1,
    fullName: 'Jane Doe',
    phone: '01012345678',
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

  const tWalkInResult = WalkInResultEntity(
    appointmentId: 10,
    appointmentNumber: 'APT-2026-001',
    queueItemId: 5,
    ticketNumber: 'A-01',
    patientId: 1,
    patientName: 'Jane Doe',
    doctorName: 'Dr. John',
    status: 'scheduled',
    replayed: false,
  );

  test('initial state should have stage 1 and valid UUID', () {
    expect(cubit.state.stage, 1);
    expect(cubit.state.clientRequestId, isNotEmpty);
    expect(cubit.state.selectedPatient, isNull);
    expect(cubit.state.selectedDoctor, isNull);
  });

  blocTest<WalkInCubit, WalkInState>(
    'init loads form context successfully',
    build: () {
      when(() => mockGetContext()).thenAnswer((_) async => const Right(tContext));
      return cubit;
    },
    act: (c) => c.init(),
    expect: () => [
      predicate<WalkInState>((s) => s.isLoadingContext && s.contextError == null),
      predicate<WalkInState>((s) => !s.isLoadingContext && s.formContext == tContext),
    ],
  );

  test('stage progression respects validation guards', () {
    expect(cubit.state.isStage1Valid, isFalse);
    cubit.nextStage();
    expect(cubit.state.stage, 1);

    cubit.selectPatient(tPatient);
    expect(cubit.state.isStage1Valid, isTrue);
    cubit.nextStage();
    expect(cubit.state.stage, 2);

    expect(cubit.state.isStage2Valid, isFalse);
    cubit.nextStage();
    expect(cubit.state.stage, 2);

    cubit.selectService(tService);
    cubit.nextStage();
    expect(cubit.state.stage, 2);

    when(() => mockGetContext(doctorId: 1))
        .thenAnswer((_) async => const Right(tContext));
    cubit.selectDoctor(tDoctor);
    expect(cubit.state.isStage2Valid, isTrue);
    cubit.nextStage();
    expect(cubit.state.stage, 3);
  });

  blocTest<WalkInCubit, WalkInState>(
    'submit creates walk-in and sets submitSuccess',
    build: () {
      when(() => mockCreateWalkIn(any()))
          .thenAnswer((_) async => const Right(tWalkInResult));
      return cubit;
    },
    seed: () => const WalkInState(
      clientRequestId: 'test-uuid',
      stage: 3,
      selectedPatient: tPatient,
      selectedDoctor: tDoctor,
      selectedService: tService,
    ),
    act: (c) => c.submit(),
    expect: () => [
      predicate<WalkInState>((s) => s.isSubmitting && s.submitError == null),
      predicate<WalkInState>((s) =>
          !s.isSubmitting &&
          s.submitSuccess &&
          s.walkInResult == tWalkInResult),
    ],
  );

  blocTest<WalkInCubit, WalkInState>(
    'submit failure sets submitError',
    build: () {
      when(() => mockCreateWalkIn(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Daily queue limit reached')),
      );
      return cubit;
    },
    seed: () => const WalkInState(
      clientRequestId: 'test-uuid',
      stage: 3,
      selectedPatient: tPatient,
      selectedDoctor: tDoctor,
      selectedService: tService,
    ),
    act: (c) => c.submit(),
    expect: () => [
      predicate<WalkInState>((s) => s.isSubmitting),
      predicate<WalkInState>((s) =>
          !s.isSubmitting &&
          !s.submitSuccess &&
          s.submitError == 'Daily queue limit reached'),
    ],
  );
}
