import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_queue/data/data_sources/doctor_queue_remote_data_source.dart';
import 'package:medical_erp/features/doctor_queue/data/models/doctor_queue_model.dart';
import 'package:medical_erp/features/doctor_queue/data/models/queue_patient_model.dart';
import 'package:medical_erp/features/doctor_queue/data/models/queue_summary_model.dart';
import 'package:medical_erp/features/doctor_queue/data/repositories/doctor_queue_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorQueueRemoteDataSource extends Mock
    implements DoctorQueueRemoteDataSource {}

void main() {
  late DoctorQueueRepositoryImpl repository;
  late MockDoctorQueueRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockDoctorQueueRemoteDataSource();
    repository = DoctorQueueRepositoryImpl(mockRemoteDataSource);
  });

  const tPatientModel = QueuePatientModel(
    id: 1,
    ticketNumber: 'A-01',
    patientName: 'أحمد علي',
    patientPhone: '01012345678',
    patientAge: 35,
    patientGender: 'ذكر',
    serviceName: 'كشف عام',
    priority: 'urgent',
    status: 'waiting',
    isUrgent: true,
    isVip: false,
    hasIntakeVitals: false,
  );

  const tSummaryModel = QueueSummaryModel(
    completedToday: 2,
    waitingCount: 1,
    withDoctorCount: 0,
    totalActive: 1,
    urgentCount: 1,
    hasUrgent: true,
  );

  const tQueueModel = DoctorQueueModel(
    items: [tPatientModel],
    summary: tSummaryModel,
  );

  group('getQueue', () {
    test('should return DoctorQueueModel when remote data source succeeds', () async {
      when(() => mockRemoteDataSource.getQueue())
          .thenAnswer((_) async => tQueueModel);

      final result = await repository.getQueue();

      expect(result, const Right(tQueueModel));
      verify(() => mockRemoteDataSource.getQueue()).called(1);
    });

    test('should return ServerFailure when remote data source throws ServerException', () async {
      when(() => mockRemoteDataSource.getQueue()).thenThrow(
        const ServerException(message: 'Server error', statusCode: 500),
      );

      final result = await repository.getQueue();

      expect(result, const Left(ServerFailure(message: 'Server error', statusCode: 500)));
    });

    test('should return NetworkFailure when remote data source throws NetworkException', () async {
      when(() => mockRemoteDataSource.getQueue()).thenThrow(
        const NetworkException(),
      );

      final result = await repository.getQueue();

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('Actions', () {
    test('callPatient succeeds', () async {
      when(() => mockRemoteDataSource.callPatient(1))
          .thenAnswer((_) async => {});

      final result = await repository.callPatient(1);

      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.callPatient(1)).called(1);
    });

    test('completePatient succeeds', () async {
      when(() => mockRemoteDataSource.completePatient(1))
          .thenAnswer((_) async => {});

      final result = await repository.completePatient(1);

      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.completePatient(1)).called(1);
    });

    test('cancelPatient succeeds', () async {
      when(() => mockRemoteDataSource.cancelPatient(1))
          .thenAnswer((_) async => {});

      final result = await repository.cancelPatient(1);

      expect(result, const Right(null));
      verify(() => mockRemoteDataSource.cancelPatient(1)).called(1);
    });
  });
}
