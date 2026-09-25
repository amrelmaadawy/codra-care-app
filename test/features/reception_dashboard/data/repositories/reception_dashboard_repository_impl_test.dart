import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_dashboard/data/data_sources/reception_dashboard_remote_data_source.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/appointment_today_stats_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/reception_dashboard_capabilities_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/models/reception_dashboard_model.dart';
import 'package:medical_erp/features/reception_dashboard/data/repositories/reception_dashboard_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockReceptionDashboardRemoteDataSource extends Mock
    implements ReceptionDashboardRemoteDataSource {}

void main() {
  late ReceptionDashboardRepositoryImpl repository;
  late MockReceptionDashboardRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockReceptionDashboardRemoteDataSource();
    repository = ReceptionDashboardRepositoryImpl(mockRemoteDataSource);
  });

  const tModel = ReceptionDashboardModel(
    appointmentsToday: AppointmentTodayStatsModel(
      scheduled: 4,
      inConsultation: 1,
      completed: 2,
      cancelled: 0,
    ),
    totalPatientsToday: 6,
    activeQueue: [],
    activeWaitingCount: 0,
    pendingFollowUpsCount: 1,
    doctors: [],
    capabilities: ReceptionDashboardCapabilitiesModel(
      canViewAppointments: true,
      canViewQueue: true,
      canViewFollowUps: true,
    ),
  );

  test(
    'should return ReceptionDashboardModel when remote data source succeeds',
    () async {
      when(
        () =>
            mockRemoteDataSource.getDashboard(doctorId: any(named: 'doctorId')),
      ).thenAnswer((_) async => tModel);

      final result = await repository.getDashboard(doctorId: 2);

      expect(result, const Right(tModel));
      verify(() => mockRemoteDataSource.getDashboard(doctorId: 2)).called(1);
    },
  );

  test(
    'should return ServerFailure when remote data source throws ServerException',
    () async {
      when(
        () =>
            mockRemoteDataSource.getDashboard(doctorId: any(named: 'doctorId')),
      ).thenThrow(
        const ServerException(message: 'Server error', statusCode: 500),
      );

      final result = await repository.getDashboard();

      expect(
        result,
        const Left(ServerFailure(message: 'Server error', statusCode: 500)),
      );
    },
  );

  test(
    'should return NetworkFailure when remote data source throws NetworkException',
    () async {
      when(
        () =>
            mockRemoteDataSource.getDashboard(doctorId: any(named: 'doctorId')),
      ).thenThrow(const NetworkException());

      final result = await repository.getDashboard();

      expect(result, const Left(NetworkFailure()));
    },
  );

  test(
    'should return UnauthorizedFailure when remote data source throws UnauthorizedException',
    () async {
      when(
        () =>
            mockRemoteDataSource.getDashboard(doctorId: any(named: 'doctorId')),
      ).thenThrow(const UnauthorizedException());

      final result = await repository.getDashboard();

      expect(result, const Left(UnauthorizedFailure()));
    },
  );
}
