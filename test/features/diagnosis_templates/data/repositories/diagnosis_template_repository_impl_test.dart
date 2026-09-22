import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/diagnosis_templates/data/data_sources/diagnosis_template_remote_data_source.dart';
import 'package:medical_erp/features/diagnosis_templates/data/models/diagnosis_template_model.dart';
import 'package:medical_erp/features/diagnosis_templates/data/models/paginated_diagnosis_templates_model.dart';
import 'package:medical_erp/features/diagnosis_templates/data/repositories/diagnosis_template_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockDiagnosisTemplateRemoteDataSource extends Mock
    implements DiagnosisTemplateRemoteDataSource {}

void main() {
  late DiagnosisTemplateRepositoryImpl repository;
  late MockDiagnosisTemplateRemoteDataSource mockDataSource;

  const tModel = DiagnosisTemplateModel(
    id: 1,
    doctorId: 4,
    title: 'قالب فحص دوري',
    chiefComplaint: 'فحص عام',
    diagnosis: 'Normal Checkup',
    notes: 'لا توجد ملاحظات',
    usageCount: 5,
  );

  const tPaginatedModel = PaginatedDiagnosisTemplatesModel(
    items: [tModel],
    currentPage: 1,
    lastPage: 1,
    total: 1,
  );

  setUp(() {
    mockDataSource = MockDiagnosisTemplateRemoteDataSource();
    repository = DiagnosisTemplateRepositoryImpl(mockDataSource);
  });

  group('getDiagnosisTemplates', () {
    test('returns Right(PaginatedDiagnosisTemplatesEntity) on success', () async {
      when(() => mockDataSource.getDiagnosisTemplates(
            page: any(named: 'page'),
            search: any(named: 'search'),
          )).thenAnswer((_) async => tPaginatedModel);

      final result = await repository.getDiagnosisTemplates(page: 2);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (data) => expect(data.items.length, 1),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      when(() => mockDataSource.getDiagnosisTemplates(
            page: any(named: 'page'),
            search: any(named: 'search'),
          )).thenThrow(const ServerException(message: 'Server error', statusCode: 500));

      final result = await repository.getDiagnosisTemplates(page: 2);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('should be left'),
      );
    });
  });

  group('createDiagnosisTemplate', () {
    test('returns Right(DiagnosisTemplateEntity) on success', () async {
      when(() => mockDataSource.createDiagnosisTemplate(
            title: any(named: 'title'),
            chiefComplaint: any(named: 'chiefComplaint'),
            diagnosis: any(named: 'diagnosis'),
            notes: any(named: 'notes'),
          )).thenAnswer((_) async => tModel);

      final result = await repository.createDiagnosisTemplate(
        title: 'قالب فحص دوري',
        diagnosis: 'Normal Checkup',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('should be right'),
        (entity) => expect(entity.title, 'قالب فحص دوري'),
      );
    });
  });

  group('deleteDiagnosisTemplate', () {
    test('returns Right(null) on success', () async {
      when(() => mockDataSource.deleteDiagnosisTemplate(any()))
          .thenAnswer((_) async => {});

      final result = await repository.deleteDiagnosisTemplate(1);

      expect(result.isRight(), true);
    });
  });
}
