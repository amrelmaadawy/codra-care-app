import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_dashboard/domain/entities/doctor_dashboard_entity.dart';
import 'package:medical_erp/features/doctor_dashboard/domain/repositories/doctor_dashboard_repository.dart';
import 'package:medical_erp/features/doctor_dashboard/domain/use_cases/get_doctor_dashboard_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorDashboardRepository extends Mock
    implements DoctorDashboardRepository {}

void main() {
  late GetDoctorDashboardUseCase useCase;
  late MockDoctorDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDoctorDashboardRepository();
    useCase = GetDoctorDashboardUseCase(mockRepository);
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

  test('should return DoctorDashboardEntity when repository succeeds', () async {
    when(() => mockRepository.getDashboardStats())
        .thenAnswer((_) async => const Right(tEntity));

    final result = await useCase();

    expect(result, const Right(tEntity));
    verify(() => mockRepository.getDashboardStats()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    const tFailure = ServerFailure(message: 'Server error');
    when(() => mockRepository.getDashboardStats())
        .thenAnswer((_) async => const Left(tFailure));

    final result = await useCase();

    expect(result, const Left(tFailure));
    verify(() => mockRepository.getDashboardStats()).called(1);
  });
}
