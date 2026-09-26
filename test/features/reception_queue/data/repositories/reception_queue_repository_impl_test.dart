import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_queue/data/data_sources/reception_queue_remote_data_source.dart';
import 'package:medical_erp/features/reception_queue/data/models/queue_capabilities_model.dart';
import 'package:medical_erp/features/reception_queue/data/models/queue_summary_model.dart';
import 'package:medical_erp/features/reception_queue/data/models/reception_queue_item_model.dart';
import 'package:medical_erp/features/reception_queue/data/models/reception_queue_model.dart';
import 'package:medical_erp/features/reception_queue/data/repositories/reception_queue_repository_impl.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/queue_filter.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ReceptionQueueRemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late ReceptionQueueRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(const QueueFilter());
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ReceptionQueueRepositoryImpl(mockRemoteDataSource);
  });

  const tItem = ReceptionQueueItemModel(
    id: 1,
    ticketNumber: 'A001',
    patientId: 10,
    patientName: 'أحمد',
    doctorId: 2,
    doctorName: 'د. محمد',
    status: 'waiting',
    priority: 'normal',
    isPresent: true,
    waitMinutes: 10,
    capabilities: QueueCapabilitiesModel(canTogglePresence: true, canCallDoctor: true),
  );

  const tQueueModel = ReceptionQueueModel(
    items: [tItem],
    summary: QueueSummaryModel(waiting: 1, total: 1),
    total: 1,
  );

  group('getQueue', () {
    test('returns Right(ReceptionQueueEntity) when successful', () async {
      when(() => mockRemoteDataSource.getQueue(any()))
          .thenAnswer((_) async => tQueueModel);

      final result = await repository.getQueue(const QueueFilter());

      expect(result, const Right(tQueueModel));
      verify(() => mockRemoteDataSource.getQueue(const QueueFilter())).called(1);
    });

    test('returns Left(Failure) when remote data source throws', () async {
      when(() => mockRemoteDataSource.getQueue(any()))
          .thenThrow(Exception('Server error'));

      final result = await repository.getQueue(const QueueFilter());

      expect(result.isLeft(), true);
    });
  });

  group('togglePresence', () {
    test('returns Right(ReceptionQueueItemEntity) on success', () async {
      when(() => mockRemoteDataSource.togglePresence(
            id: 1,
            isPresent: false,
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => tItem);

      final result = await repository.togglePresence(id: 1, isPresent: false);

      expect(result, const Right(tItem));
    });
  });

  group('saveVitals', () {
    test('returns Right(ReceptionQueueItemEntity) on success', () async {
      when(() => mockRemoteDataSource.saveVitals(
            id: 1,
            vitals: any(named: 'vitals'),
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => tItem);

      final result = await repository.saveVitals(id: 1, vitals: {'bp_systolic': 120});

      expect(result, const Right(tItem));
    });
  });

  group('callDoctor', () {
    test('returns Right(ReceptionQueueItemEntity) on success', () async {
      when(() => mockRemoteDataSource.callDoctor(
            id: 1,
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => tItem);

      final result = await repository.callDoctor(id: 1);

      expect(result, const Right(tItem));
    });
  });

  group('complete', () {
    test('returns Right(ReceptionQueueItemEntity) on success', () async {
      when(() => mockRemoteDataSource.complete(
            id: 1,
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => tItem);

      final result = await repository.complete(id: 1);

      expect(result, const Right(tItem));
    });
  });

  group('cancel', () {
    test('returns Right(ReceptionQueueItemEntity) on success', () async {
      when(() => mockRemoteDataSource.cancel(
            id: 1,
            reason: 'غادر المريض',
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => tItem);

      final result = await repository.cancel(id: 1, reason: 'غادر المريض');

      expect(result, const Right(tItem));
    });
  });
}
