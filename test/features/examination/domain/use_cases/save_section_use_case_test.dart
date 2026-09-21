import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/examination/domain/repositories/examination_repository.dart';
import 'package:medical_erp/features/examination/domain/use_cases/save_section_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockExaminationRepository extends Mock implements ExaminationRepository {}

void main() {
  late SaveSectionUseCase useCase;
  late MockExaminationRepository mockRepository;

  setUp(() {
    mockRepository = MockExaminationRepository();
    useCase = SaveSectionUseCase(mockRepository);
  });

  const tVisitId = 1;
  const tSection = 'examination_notes';
  const tData = {'chief_complaint': 'الصداع المستمر'};
  const tResult = {'chief_complaint': 'الصداع المستمر'};

  test('should return data when repository succeeds', () async {
    when(() => mockRepository.saveSection(
          visitId: tVisitId,
          section: tSection,
          data: tData,
        )).thenAnswer((_) async => const Right(tResult));

    final result = await useCase(
      visitId: tVisitId,
      section: tSection,
      data: tData,
    );

    expect(result, const Right(tResult));
    verify(() => mockRepository.saveSection(
          visitId: tVisitId,
          section: tSection,
          data: tData,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    when(() => mockRepository.saveSection(
          visitId: tVisitId,
          section: tSection,
          data: tData,
        )).thenAnswer((_) async => const Left(ServerFailure(message: 'Save failed')));

    final result = await useCase(
      visitId: tVisitId,
      section: tSection,
      data: tData,
    );

    expect(result, const Left(ServerFailure(message: 'Save failed')));
    verify(() => mockRepository.saveSection(
          visitId: tVisitId,
          section: tSection,
          data: tData,
        )).called(1);
  });
}
