import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/domain/repositories/prescription_repository.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/mark_printed_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockPrescriptionRepository extends Mock
    implements PrescriptionRepository {}

void main() {
  late MarkPrintedUseCase useCase;
  late MockPrescriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockPrescriptionRepository();
    useCase = MarkPrintedUseCase(mockRepository);
  });

  const tId = 5;

  test('should call markPrinted on repository and return Right(null)', () async {
    when(() => mockRepository.markPrinted(tId))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(tId);

    expect(result, const Right(null));
    verify(() => mockRepository.markPrinted(tId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    when(() => mockRepository.markPrinted(tId))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

    final result = await useCase(tId);

    expect(result, const Left(ServerFailure(message: 'Error')));
    verify(() => mockRepository.markPrinted(tId)).called(1);
  });
}
