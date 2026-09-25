import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/appointment_today_stats_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_capabilities_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/entities/reception_dashboard_entity.dart';
import 'package:medical_erp/features/reception_dashboard/domain/use_cases/get_reception_dashboard_use_case.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/cubits/reception_dashboard_cubit.dart';
import 'package:medical_erp/features/reception_dashboard/presentation/cubits/reception_dashboard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetReceptionDashboardUseCase extends Mock
    implements GetReceptionDashboardUseCase {}

void main() {
  late ReceptionDashboardCubit cubit;
  late MockGetReceptionDashboardUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const GetReceptionDashboardParams());
  });

  setUp(() {
    mockUseCase = MockGetReceptionDashboardUseCase();
    cubit = ReceptionDashboardCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  const tEntity = ReceptionDashboardEntity(
    appointmentsToday: AppointmentTodayStatsEntity(
      scheduled: 3,
      inConsultation: 1,
      completed: 2,
      cancelled: 0,
    ),
    totalPatientsToday: 5,
    activeQueue: [],
    activeWaitingCount: 0,
    pendingFollowUpsCount: 1,
    doctors: [],
    capabilities: ReceptionDashboardCapabilitiesEntity(
      canViewAppointments: true,
      canViewQueue: true,
      canViewFollowUps: true,
    ),
  );

  test('initial state should be ReceptionDashboardInitial', () {
    expect(cubit.state, const ReceptionDashboardInitial());
  });

  blocTest<ReceptionDashboardCubit, ReceptionDashboardState>(
    'emits [ReceptionDashboardLoading, ReceptionDashboardLoaded] when load succeeds',
    build: () {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Right(tEntity));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const ReceptionDashboardLoading(),
      const ReceptionDashboardLoaded(data: tEntity),
    ],
  );

  blocTest<ReceptionDashboardCubit, ReceptionDashboardState>(
    'emits [ReceptionDashboardLoading, ReceptionDashboardError] when load fails',
    build: () {
      const tFailure = ServerFailure(message: 'Server error');
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Left(tFailure));
      return cubit;
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      const ReceptionDashboardLoading(),
      const ReceptionDashboardError(ServerFailure(message: 'Server error')),
    ],
  );

  blocTest<ReceptionDashboardCubit, ReceptionDashboardState>(
    'selectDoctor sets isQueueRefreshing, keeps existing data, then updates',
    build: () {
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Right(tEntity));
      return cubit;
    },
    seed: () => const ReceptionDashboardLoaded(data: tEntity),
    act: (cubit) => cubit.selectDoctor(3),
    expect: () => [
      const ReceptionDashboardLoaded(
        data: tEntity,
        selectedDoctorId: 3,
        isQueueRefreshing: true,
      ),
      const ReceptionDashboardLoaded(
        data: tEntity,
        selectedDoctorId: 3,
      ),
    ],
  );

  blocTest<ReceptionDashboardCubit, ReceptionDashboardState>(
    'silent refresh retains current data and sets refreshWarning on failure',
    build: () {
      const tFailure = ServerFailure(message: 'Connection timed out');
      when(
        () => mockUseCase(any()),
      ).thenAnswer((_) async => const Left(tFailure));
      return cubit;
    },
    seed: () => const ReceptionDashboardLoaded(data: tEntity),
    act: (cubit) => cubit.refresh(isSilent: true),
    expect: () => [
      const ReceptionDashboardLoaded(
        data: tEntity,
        refreshWarning: 'Connection timed out',
      ),
    ],
  );

  test('does not throw when closed', () async {
    await cubit.close();
    expect(cubit.isClosed, isTrue);
  });
}
