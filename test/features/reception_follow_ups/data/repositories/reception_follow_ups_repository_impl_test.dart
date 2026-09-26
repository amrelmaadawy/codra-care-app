import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_follow_ups/data/datasources/reception_follow_ups_remote_data_source.dart';
import 'package:medical_erp/features/reception_follow_ups/data/models/follow_up_summary_model.dart';
import 'package:medical_erp/features/reception_follow_ups/data/models/follow_ups_page_model.dart';
import 'package:medical_erp/features/reception_follow_ups/data/models/reception_follow_up_model.dart';
import 'package:medical_erp/features/reception_follow_ups/data/repositories/reception_follow_ups_repository_impl.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/get_follow_ups_params.dart';
import 'package:medical_erp/features/reception_follow_ups/domain/entities/reception_follow_up_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements ReceptionFollowUpsRemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late ReceptionFollowUpsRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const GetFollowUpsParams());
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ReceptionFollowUpsRepositoryImpl(mockRemoteDataSource);
  });

  const tItem = ReceptionFollowUpModel(
    id: 1,
    visitId: 10,
    visitNumber: 'V-001',
    patientId: 2,
    patientName: 'Jane Doe',
    patientPhone: '01000000000',
    doctorId: 1,
    doctorName: 'Dr. House',
    doctorSpecialization: 'Internal Medicine',
    serviceName: 'General Consultation',
    servicePrice: 200.0,
    dueDate: '2026-09-27',
    daysDelta: 1,
    urgency: FollowUpUrgency.upcoming,
    instructions: 'Check lab results',
    canSchedule: true,
  );

  const tSummary = FollowUpSummaryModel(
    totalPending: 1,
    overdueCount: 0,
    todayCount: 0,
    upcomingCount: 1,
  );

  const tPage = FollowUpsPageModel(
    items: [tItem],
    summary: tSummary,
    currentPage: 1,
    lastPage: 1,
    total: 1,
  );

  group('ReceptionFollowUpsRepositoryImpl', () {
    test('returns Right(FollowUpsPageEntity) when remote call succeeds', () async {
      when(() => mockRemoteDataSource.getFollowUps(any()))
          .thenAnswer((_) async => tPage);

      final result = await repository.getFollowUps(const GetFollowUpsParams());

      expect(result, const Right(tPage));
      verify(() => mockRemoteDataSource.getFollowUps(any())).called(1);
    });

    test('returns Left(ServerFailure) when remote call throws ServerException', () async {
      when(() => mockRemoteDataSource.getFollowUps(any()))
          .thenThrow(const ServerException(message: 'Failed to fetch', statusCode: 500));

      final result = await repository.getFollowUps(const GetFollowUpsParams());

      expect(result, const Left(ServerFailure(message: 'Failed to fetch', statusCode: 500)));
    });

    test('returns Left(ServerFailure) when unexpected exception occurs', () async {
      when(() => mockRemoteDataSource.getFollowUps(any()))
          .thenThrow(Exception('Unknown network failure'));

      final result = await repository.getFollowUps(const GetFollowUpsParams());

      expect(result.isLeft(), isTrue);
    });
  });
}
