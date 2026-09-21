import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/examination/data/data_sources/examination_remote_data_source.dart';
import 'package:medical_erp/features/examination/data/models/examination_model.dart';
import 'package:medical_erp/features/examination/data/models/visit_image_model.dart';
import 'package:medical_erp/features/examination/data/models/visit_patient_model.dart';
import 'package:medical_erp/features/examination/data/repositories/examination_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockExaminationRemoteDataSource extends Mock
    implements ExaminationRemoteDataSource {}

void main() {
  late ExaminationRepositoryImpl repository;
  late MockExaminationRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockExaminationRemoteDataSource();
    repository = ExaminationRepositoryImpl(mockDataSource);
  });

  const tPatient = VisitPatientModel(
    id: 1,
    name: 'أحمد علي',
    phone: '01012345678',
    gender: 'male',
    age: 30,
  );

  const tExamModel = ExaminationModel(
    id: 10,
    visitNumber: 'VST-100',
    status: 'in_progress',
    patient: tPatient,
    chiefComplaint: 'ألم في البطن',
    diagnosis: 'التهاب معدة',
  );

  const tImageModel = VisitImageModel(
    id: 1,
    url: 'visits/10/img.jpg',
    fullUrl: 'http://localhost/storage/visits/10/img.jpg',
    type: 'scan',
  );

  group('startExamination', () {
    test('returns visitId on success', () async {
      when(() => mockDataSource.startExamination(1))
          .thenAnswer((_) async => 10);

      final result = await repository.startExamination(1);

      expect(result, const Right(10));
      verify(() => mockDataSource.startExamination(1)).called(1);
    });

    test('returns ServerFailure when dataSource throws ServerException', () async {
      when(() => mockDataSource.startExamination(1)).thenThrow(
        const ServerException(message: 'Error starting', statusCode: 500),
      );

      final result = await repository.startExamination(1);

      expect(result, const Left(ServerFailure(message: 'Error starting', statusCode: 500)));
    });
  });

  group('getExamination', () {
    test('returns ExaminationEntity on success', () async {
      when(() => mockDataSource.getExamination(10))
          .thenAnswer((_) async => tExamModel);

      final result = await repository.getExamination(10);

      expect(result, const Right(tExamModel));
      verify(() => mockDataSource.getExamination(10)).called(1);
    });

    test('returns NetworkFailure on NetworkException', () async {
      when(() => mockDataSource.getExamination(10))
          .thenThrow(const NetworkException());

      final result = await repository.getExamination(10);

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('saveSection', () {
    test('returns section data on success', () async {
      const data = {'chief_complaint': 'ألم في البطن'};
      when(() => mockDataSource.saveSection(
            visitId: 10,
            section: 'examination_notes',
            data: data,
          )).thenAnswer((_) async => data);

      final result = await repository.saveSection(
        visitId: 10,
        section: 'examination_notes',
        data: data,
      );

      expect(result, const Right(data));
    });
  });

  group('uploadFiles', () {
    test('returns uploaded images on success', () async {
      when(() => mockDataSource.uploadFiles(
            visitId: 10,
            filePaths: ['/path/to/file.jpg'],
            type: 'scan',
          )).thenAnswer((_) async => [tImageModel]);

      final result = await repository.uploadFiles(
        visitId: 10,
        filePaths: ['/path/to/file.jpg'],
        type: 'scan',
      );

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(() => []), [tImageModel]);
    });
  });

  group('deleteFile', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.deleteFile(visitId: 10, imageId: 1))
          .thenAnswer((_) async => {});

      final result = await repository.deleteFile(visitId: 10, imageId: 1);

      expect(result, const Right(null));
    });
  });

  group('completeExamination', () {
    test('returns Right(null) on success', () async {
      const data = {'chief_complaint': 'ألم', 'diagnosis': 'سليم'};
      when(() => mockDataSource.completeExamination(visitId: 10, data: data))
          .thenAnswer((_) async => {});

      final result = await repository.completeExamination(visitId: 10, data: data);

      expect(result, const Right(null));
    });

    test('returns ValidationFailure when ServerException has fieldErrors', () async {
      const data = {'chief_complaint': '', 'diagnosis': ''};
      when(() => mockDataSource.completeExamination(visitId: 10, data: data)).thenThrow(
        const ServerException(
          message: 'Validation failed',
          statusCode: 422,
          fieldErrors: {'chief_complaint': ['مطلوب']},
        ),
      );

      final result = await repository.completeExamination(visitId: 10, data: data);

      expect(
        result,
        const Left(ValidationFailure(
          message: 'Validation failed',
          fieldErrors: {'chief_complaint': ['مطلوب']},
        )),
      );
    });
  });

  group('copyPreviousVisit', () {
    test('returns copied data on success', () async {
      const data = {'chief_complaint': 'شكوى سابقة', 'diagnosis': 'تشخيص سابق'};
      when(() => mockDataSource.copyPreviousVisit(visitId: 10, prevId: 5))
          .thenAnswer((_) async => data);

      final result = await repository.copyPreviousVisit(visitId: 10, prevId: 5);

      expect(result, const Right(data));
    });
  });
}
