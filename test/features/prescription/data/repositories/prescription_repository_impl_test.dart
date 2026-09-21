import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/data/data_sources/prescription_remote_data_source.dart';
import 'package:medical_erp/features/prescription/data/models/paginated_prescriptions_model.dart';
import 'package:medical_erp/features/prescription/data/models/prescription_context_model.dart';
import 'package:medical_erp/features/prescription/data/models/prescription_item_model.dart';
import 'package:medical_erp/features/prescription/data/models/prescription_model.dart';
import 'package:medical_erp/features/prescription/data/models/prescription_patient_model.dart';
import 'package:medical_erp/features/prescription/data/repositories/prescription_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockPrescriptionRemoteDataSource extends Mock
    implements PrescriptionRemoteDataSource {}

void main() {
  late PrescriptionRepositoryImpl repository;
  late MockPrescriptionRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPrescriptionRemoteDataSource();
    repository = PrescriptionRepositoryImpl(mockDataSource);
  });

  const tPatient = PrescriptionPatientModel(
    id: 1,
    fullName: 'محمود حسن',
    phone: '01011122233',
  );

  const tItem = PrescriptionItemModel(
    id: 101,
    drugName: 'Panadol Extra',
    dosage: '500mg',
    frequency: 'TDS',
    duration: '5 days',
  );

  const tRx = PrescriptionModel(
    id: 10,
    prescriptionNumber: 'RX-10',
    patient: tPatient,
    visitId: 5,
    items: [tItem],
  );

  const tPaginated = PaginatedPrescriptionsModel(
    items: [tRx],
    currentPage: 1,
    lastPage: 1,
    total: 1,
  );

  group('getPrescriptions', () {
    test('returns PaginatedPrescriptionsEntity on success', () async {
      when(() => mockDataSource.getPrescriptions(
            search: any(named: 'search'),
            dateFrom: any(named: 'dateFrom'),
            dateTo: any(named: 'dateTo'),
            isPrinted: any(named: 'isPrinted'),
          )).thenAnswer((_) async => tPaginated);

      final result = await repository.getPrescriptions();
      expect(result, const Right(tPaginated));
      verify(() => mockDataSource.getPrescriptions()).called(1);
    });

    test('returns ServerFailure on ServerException', () async {
      when(() => mockDataSource.getPrescriptions()).thenThrow(
        const ServerException(message: 'Server Error', statusCode: 500),
      );
      final result = await repository.getPrescriptions();
      expect(result, const Left(ServerFailure(message: 'Server Error', statusCode: 500)));
    });

    test('returns NetworkFailure on NetworkException', () async {
      when(() => mockDataSource.getPrescriptions()).thenThrow(
        const NetworkException(),
      );
      final result = await repository.getPrescriptions();
      expect(result, const Left(NetworkFailure()));
    });
  });

  group('getCreateContext & getPrescriptionDetail', () {
    test('returns PrescriptionContextEntity on success', () async {
      const tContext = PrescriptionContextModel(patient: tPatient, visitId: 5);
      when(() => mockDataSource.getCreateContext(visitId: 5, patientId: 1))
          .thenAnswer((_) async => tContext);
      final result = await repository.getCreateContext(visitId: 5, patientId: 1);
      expect(result, const Right(tContext));
    });

    test('returns PrescriptionEntity on detail success', () async {
      when(() => mockDataSource.getPrescriptionDetail(10))
          .thenAnswer((_) async => tRx);
      final result = await repository.getPrescriptionDetail(10);
      expect(result, const Right(tRx));
    });

    test('returns NotFoundFailure when NotFoundException is thrown', () async {
      when(() => mockDataSource.getPrescriptionDetail(10))
          .thenThrow(const NotFoundException());
      final result = await repository.getPrescriptionDetail(10);
      expect(result, const Left(NotFoundFailure()));
    });
  });

  group('create, update, delete, copy', () {
    final tItemsPayload = [tItem.toJson()];

    test('createPrescription returns PrescriptionEntity on success', () async {
      when(() => mockDataSource.createPrescription(
            patientId: 1,
            visitId: 5,
            notes: 'Test',
            items: tItemsPayload,
          )).thenAnswer((_) async => tRx);

      final result = await repository.createPrescription(
        patientId: 1,
        visitId: 5,
        notes: 'Test',
        items: tItemsPayload,
      );
      expect(result, const Right(tRx));
    });

    test('createPrescription returns ValidationFailure on field errors', () async {
      when(() => mockDataSource.createPrescription(
            patientId: 1,
            items: tItemsPayload,
          )).thenThrow(
        const ServerException(
          message: 'Invalid data',
          statusCode: 422,
          fieldErrors: {'items': ['Items required']},
        ),
      );

      final result = await repository.createPrescription(
        patientId: 1,
        items: tItemsPayload,
      );
      expect(
        result,
        const Left(ValidationFailure(
          message: 'Invalid data',
          fieldErrors: {'items': ['Items required']},
        )),
      );
    });

    test('updatePrescription returns updated entity', () async {
      when(() => mockDataSource.updatePrescription(
            id: 10,
            patientId: 1,
            items: tItemsPayload,
          )).thenAnswer((_) async => tRx);

      final result = await repository.updatePrescription(
        id: 10,
        patientId: 1,
        items: tItemsPayload,
      );
      expect(result, const Right(tRx));
    });

    test('deletePrescription returns Right(null) on success', () async {
      when(() => mockDataSource.deletePrescription(10))
          .thenAnswer((_) async => {});
      final result = await repository.deletePrescription(10);
      expect(result, const Right(null));
    });

    test('copyPrescription returns copied PrescriptionEntity', () async {
      when(() => mockDataSource.copyPrescription(10))
          .thenAnswer((_) async => tRx);
      final result = await repository.copyPrescription(10);
      expect(result, const Right(tRx));
    });
  });
}
