import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_doctor_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_enums.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_filters.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_patient_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointment_service_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/entities/appointments_page_entity.dart';
import 'package:medical_erp/features/reception_appointments/domain/usecases/cancel_appointment_use_case.dart';
import 'package:medical_erp/features/reception_appointments/domain/usecases/check_in_appointment_use_case.dart';
import 'package:medical_erp/features/reception_appointments/domain/usecases/get_appointments_use_case.dart';
import 'package:medical_erp/features/reception_appointments/domain/usecases/get_calendar_events_use_case.dart';
import 'package:medical_erp/features/reception_appointments/presentation/cubits/appointments_cubit.dart';
import 'package:medical_erp/features/reception_appointments/presentation/cubits/appointments_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAppointmentsUseCase extends Mock
    implements GetAppointmentsUseCase {}

class MockGetCalendarEventsUseCase extends Mock
    implements GetCalendarEventsUseCase {}

class MockCancelAppointmentUseCase extends Mock
    implements CancelAppointmentUseCase {}

class MockCheckInAppointmentUseCase extends Mock
    implements CheckInAppointmentUseCase {}

void main() {
  late AppointmentsCubit cubit;
  late MockGetAppointmentsUseCase mockGetAppointmentsUseCase;
  late MockGetCalendarEventsUseCase mockGetCalendarEventsUseCase;
  late MockCancelAppointmentUseCase mockCancelAppointmentUseCase;
  late MockCheckInAppointmentUseCase mockCheckInAppointmentUseCase;

  setUpAll(() {
    registerFallbackValue(const AppointmentFilters(date: '2026-09-25'));
  });

  setUp(() {
    mockGetAppointmentsUseCase = MockGetAppointmentsUseCase();
    mockGetCalendarEventsUseCase = MockGetCalendarEventsUseCase();
    mockCancelAppointmentUseCase = MockCancelAppointmentUseCase();
    mockCheckInAppointmentUseCase = MockCheckInAppointmentUseCase();

    cubit = AppointmentsCubit(
      getAppointmentsUseCase: mockGetAppointmentsUseCase,
      getCalendarEventsUseCase: mockGetCalendarEventsUseCase,
      cancelAppointmentUseCase: mockCancelAppointmentUseCase,
      checkInAppointmentUseCase: mockCheckInAppointmentUseCase,
    );
  });

  tearDown(() => cubit.close());

  const tPatient = AppointmentPatientEntity(
    id: 1,
    fullName: 'John Doe',
    phone: '01012345678',
  );
  const tDoctor = AppointmentDoctorEntity(
    id: 2,
    name: 'Dr. Smith',
    specialization: 'Cardiology',
  );
  const tService = AppointmentServiceEntity(
    id: 3,
    name: 'Checkup',
    price: 150.0,
    durationMinutes: 15,
    isPackage: false,
  );
  const tAppointment = AppointmentEntity(
    id: 10,
    appointmentNumber: 'APT-10',
    appointmentDate: '2026-09-25',
    status: AppointmentStatus.scheduled,
    bookingType: BookingType.firstVisit,
    bookingMode: AppointmentBookingMode.scheduled,
    servicePrice: 150.0,
    patient: tPatient,
    doctor: tDoctor,
    service: tService,
    canCancel: true,
  );

  const tPage = AppointmentsPageEntity(
    items: [tAppointment],
    currentPage: 1,
    lastPage: 1,
    perPage: 20,
    total: 1,
    hasMore: false,
    appliedFilters: AppointmentFilters(date: '2026-09-25'),
  );

  test('initial state should be AppointmentsInitial', () {
    expect(cubit.state, const AppointmentsInitial());
  });

  blocTest<AppointmentsCubit, AppointmentsState>(
    'emits [AppointmentsLoading, AppointmentsLoaded] when loadInitial succeeds',
    build: () {
      when(
        () => mockGetAppointmentsUseCase(
          filters: any(named: 'filters'),
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer((_) async => const Right(tPage));
      when(
        () => mockGetCalendarEventsUseCase(
          month: any(named: 'month'),
          doctorId: any(named: 'doctorId'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => const Right([]));
      return cubit;
    },
    act: (cubit) => cubit.loadInitial(initialDate: '2026-09-25'),
    expect: () => [
      const AppointmentsLoading(),
      isA<AppointmentsLoaded>()
          .having((s) => s.selectedDate, 'selectedDate', '2026-09-25')
          .having((s) => s.items.length, 'items.length', 1),
    ],
  );

  blocTest<AppointmentsCubit, AppointmentsState>(
    'emits [AppointmentsLoading, AppointmentsError] on failure',
    build: () {
      when(
        () => mockGetAppointmentsUseCase(
          filters: any(named: 'filters'),
          page: any(named: 'page'),
          perPage: any(named: 'perPage'),
        ),
      ).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Connection error')),
      );
      when(
        () => mockGetCalendarEventsUseCase(month: any(named: 'month')),
      ).thenAnswer((_) async => const Right([]));
      return cubit;
    },
    act: (cubit) => cubit.loadInitial(initialDate: '2026-09-25'),
    expect: () => [
      const AppointmentsLoading(),
      isA<AppointmentsError>().having(
        (s) => s.message,
        'message',
        'Connection error',
      ),
    ],
  );

  blocTest<AppointmentsCubit, AppointmentsState>(
    'cancelAppointment updates appointment state to cancelled',
    build: () {
      const cancelledAppt = AppointmentEntity(
        id: 10,
        appointmentNumber: 'APT-10',
        appointmentDate: '2026-09-25',
        status: AppointmentStatus.cancelled,
        bookingType: BookingType.firstVisit,
        bookingMode: AppointmentBookingMode.scheduled,
        servicePrice: 150.0,
        patient: tPatient,
        doctor: tDoctor,
        service: tService,
        canCancel: false,
      );
      when(
        () => mockCancelAppointmentUseCase(
          appointmentId: 10,
          reason: 'Patient request',
        ),
      ).thenAnswer((_) async => const Right(cancelledAppt));
      return cubit;
    },
    seed: () => const AppointmentsLoaded(
      page: tPage,
      calendarDays: [],
      selectedDate: '2026-09-25',
      currentMonth: '2026-09',
    ),
    act: (cubit) =>
        cubit.cancelAppointment(appointmentId: 10, reason: 'Patient request'),
    expect: () => [
      isA<AppointmentsLoaded>().having(
        (s) => s.cancellingId,
        'cancellingId',
        10,
      ),
      isA<AppointmentsLoaded>()
          .having((s) => s.cancellingId, 'cancellingId', isNull)
          .having(
            (s) => s.items.first.status,
            'status',
            AppointmentStatus.cancelled,
          )
          .having((s) => s.cancelSuccessMessage, 'successMessage', isNotNull),
    ],
  );
}
