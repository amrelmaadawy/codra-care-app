import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_dashboard/domain/entities/doctor_dashboard_entity.dart';
import 'package:medical_erp/features/doctor_dashboard/domain/use_cases/get_doctor_dashboard_use_case.dart';
import 'package:medical_erp/features/doctor_dashboard/presentation/cubits/doctor_dashboard_cubit.dart';
import 'package:medical_erp/features/doctor_dashboard/presentation/cubits/doctor_dashboard_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorDashboardUseCase extends Mock
    implements GetDoctorDashboardUseCase {}

void main() {
  late DoctorDashboardCubit cubit;
  late MockGetDoctorDashboardUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetDoctorDashboardUseCase();
    cubit = DoctorDashboardCubit(mockUseCase);
  });

  const tEntity = DoctorDashboardEntity(
    doctorId: 5,
    doctorName: 'د. عمرو المعداوي',
    specialization: 'طب وجراحة عامة',
    todayQueueCount: 12,
    waitingCount: 3,
    withDoctorCount: 1,
    completedToday: 8,
    todayAppointmentsCount: 5,
    pendingFollowUps: 2,
    revenueMonth: 5400.0,
    patientsToday: 12,
    patientsMonth: 87,
    patientsTotal: 1204,
  );

  test('initial state should be DoctorDashboardInitial', () {
    expect(cubit.state, const DoctorDashboardInitial());
  });

  blocTest<DoctorDashboardCubit, DoctorDashboardState>(
    'emits [DoctorDashboardLoading, DoctorDashboardLoaded] when loadDashboard succeeds',
    build: () {
      when(() => mockUseCase()).thenAnswer((_) async => const Right(tEntity));
      return cubit;
    },
    act: (cubit) => cubit.loadDashboard(),
    expect: () => [
      const DoctorDashboardLoading(),
      const DoctorDashboardLoaded(tEntity),
    ],
  );

  blocTest<DoctorDashboardCubit, DoctorDashboardState>(
    'emits [DoctorDashboardLoading, DoctorDashboardError] when loadDashboard fails',
    build: () {
      const tFailure = ServerFailure(message: 'Server error');
      when(() => mockUseCase()).thenAnswer((_) async => const Left(tFailure));
      return cubit;
    },
    act: (cubit) => cubit.loadDashboard(),
    expect: () => [
      const DoctorDashboardLoading(),
      const DoctorDashboardError(ServerFailure(message: 'Server error')),
    ],
  );

  blocTest<DoctorDashboardCubit, DoctorDashboardState>(
    'emits [DoctorDashboardLoaded] on successful refresh',
    build: () {
      when(() => mockUseCase()).thenAnswer((_) async => const Right(tEntity));
      return cubit;
    },
    act: (cubit) => cubit.refresh(),
    expect: () => [
      const DoctorDashboardLoaded(tEntity),
    ],
  );

  test('does not throw when emit is called after close', () async {
    await cubit.close();
    expect(
      () => cubit.emit(const DoctorDashboardLoaded(tEntity)),
      returnsNormally,
    );
  });
}
