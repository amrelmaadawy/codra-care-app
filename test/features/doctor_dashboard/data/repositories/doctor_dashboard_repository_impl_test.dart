import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_dashboard/data/data_sources/doctor_dashboard_remote_data_source.dart';
import 'package:medical_erp/features/doctor_dashboard/data/models/doctor_dashboard_model.dart';
import 'package:medical_erp/features/doctor_dashboard/data/repositories/doctor_dashboard_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorDashboardRemoteDataSource extends Mock
    implements DoctorDashboardRemoteDataSource {}

void main() {
  late DoctorDashboardRepositoryImpl repository;
  late MockDoctorDashboardRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockDoctorDashboardRemoteDataSource();
    repository = DoctorDashboardRepositoryImpl(mockRemoteDataSource);
  });

  const tModel = DoctorDashboardModel(
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

  test('should return DoctorDashboardModel when remote data source succeeds',
      () async {
    when(() => mockRemoteDataSource.getDashboardStats())
        .thenAnswer((_) async => tModel);

    final result = await repository.getDashboardStats();

    expect(result, const Right(tModel));
    verify(() => mockRemoteDataSource.getDashboardStats()).called(1);
  });

  test('should return ServerFailure when remote data source throws ServerException',
      () async {
    when(() => mockRemoteDataSource.getDashboardStats()).thenThrow(
      const ServerException(message: 'Server error', statusCode: 500),
    );

    final result = await repository.getDashboardStats();

    expect(result, const Left(ServerFailure(message: 'Server error', statusCode: 500)));
  });

  test('should return NetworkFailure when remote data source throws NetworkException',
      () async {
    when(() => mockRemoteDataSource.getDashboardStats())
        .thenThrow(const NetworkException());

    final result = await repository.getDashboardStats();

    expect(result, const Left(NetworkFailure()));
  });

  test('should return UnauthorizedFailure when remote data source throws UnauthorizedException',
      () async {
    when(() => mockRemoteDataSource.getDashboardStats())
        .thenThrow(const UnauthorizedException());

    final result = await repository.getDashboardStats();

    expect(result, const Left(UnauthorizedFailure()));
  });
}
