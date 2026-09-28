import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_doctor_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_patient_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/booking_service_entity.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/create_walk_in_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/get_booking_form_context_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/usecases/search_patients_use_case.dart';
import 'package:medical_erp/features/reception_booking/domain/entities/walk_in_params.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/walk_in_cubit.dart';
import 'package:medical_erp/features/reception_booking/presentation/cubits/walk_in_state.dart';

class MockGetBookingFormContextUseCase extends Mock implements GetBookingFormContextUseCase {}
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

  const tPatient = BookingPatientEntity(id: 1, fullName: 'Ahmed Ali', phone: '01012345678');
  const tDoctor = BookingDoctorEntity(
    id: 1,
    name: 'Dr. John',
    specialization: 'General',
    scheduleMode: 'queue',
    requiresTime: false,
  );
  const tService = BookingServiceEntity(
    id: 1,
    name: 'Consultation',
    price: 100,
    durationMinutes: 15,
    isPackage: false,
  );

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

  blocTest<WalkInCubit, WalkInState>(
    'searchPatients with empty string immediately queries without debounce',
    build: () {
      when(() => mockSearch('')).thenAnswer((_) async => const Right([tPatient]));
      return cubit;
    },
    act: (c) => c.searchPatients(''),
    expect: () => [
      predicate<WalkInState>((s) => s.isSearching),
      predicate<WalkInState>((s) => !s.isSearching && s.searchResults.length == 1),
    ],
    verify: (_) => verify(() => mockSearch('')).called(1),
  );

  blocTest<WalkInCubit, WalkInState>(
    'searchPatients with single letter debounces and returns results',
    build: () {
      when(() => mockSearch('a')).thenAnswer((_) async => const Right([tPatient]));
      return cubit;
    },
    act: (c) => c.searchPatients('a'),
    wait: const Duration(milliseconds: 300),
    expect: () => [
      predicate<WalkInState>((s) => s.isSearching),
      predicate<WalkInState>((s) =>
          !s.isSearching &&
          s.searchResults.isNotEmpty &&
          s.searchResults.first.fullName == 'Ahmed Ali'),
    ],
    verify: (_) => verify(() => mockSearch('a')).called(1),
  );

  blocTest<WalkInCubit, WalkInState>(
    'submit with invalid vital signs emits submitError without calling use case',
    build: () => cubit,
    seed: () => const WalkInState(
      clientRequestId: 'test-uuid',
      stage: 3,
      selectedPatient: tPatient,
      selectedDoctor: tDoctor,
      selectedService: tService,
      vitalSigns: {'pulse': 1231231},
    ),
    act: (c) => c.submit(),
    expect: () => [
      predicate<WalkInState>((s) =>
          !s.isSubmitting &&
          !s.submitSuccess &&
          s.submitError != null &&
          s.submitError!.isNotEmpty),
    ],
    verify: (_) => verifyNever(() => mockCreateWalkIn(any())),
  );
}
