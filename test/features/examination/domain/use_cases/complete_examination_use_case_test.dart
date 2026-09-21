import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/examination/domain/repositories/examination_repository.dart';
import 'package:medical_erp/features/examination/domain/use_cases/complete_examination_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockExaminationRepository extends Mock implements ExaminationRepository {}

void main() {
  late CompleteExaminationUseCase useCase;
  late MockExaminationRepository mockRepository;

  setUp(() {
    mockRepository = MockExaminationRepository();
    useCase = CompleteExaminationUseCase(mockRepository);
  });

  const tVisitId = 1;
  const tData = {
    'chief_complaint': 'الصداع المستمر',
    'diagnosis': 'صداع نصفي',
  };

  test('should return Right(null) when repository succeeds', () async {
    when(() => mockRepository.completeExamination(
          visitId: tVisitId,
          data: tData,
        )).thenAnswer((_) async => const Right(null));

    final result = await useCase(
      visitId: tVisitId,
      data: tData,
    );

    expect(result, const Right(null));
    verify(() => mockRepository.completeExamination(
          visitId: tVisitId,
          data: tData,
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ValidationFailure when repository returns validation error', () async {
    when(() => mockRepository.completeExamination(
          visitId: tVisitId,
          data: tData,
        )).thenAnswer((_) async => const Left(ValidationFailure(
          message: 'الحقول مطلوبة',
          fieldErrors: {'diagnosis': ['التشخيص مطلوب']},
        )));

    final result = await useCase(
      visitId: tVisitId,
      data: tData,
    );

    expect(
      result,
      const Left(ValidationFailure(
        message: 'الحقول مطلوبة',
        fieldErrors: {'diagnosis': ['التشخيص مطلوب']},
      )),
    );
  });
}
