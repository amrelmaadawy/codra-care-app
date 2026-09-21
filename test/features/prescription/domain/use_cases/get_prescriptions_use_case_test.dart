import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/domain/entities/paginated_prescriptions_entity.dart';
import 'package:medical_erp/features/prescription/domain/repositories/prescription_repository.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/get_prescriptions_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockPrescriptionRepository extends Mock implements PrescriptionRepository {}

void main() {
  late GetPrescriptionsUseCase useCase;
  late MockPrescriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockPrescriptionRepository();
    useCase = GetPrescriptionsUseCase(mockRepository);
  });

  const tPaginated = PaginatedPrescriptionsEntity(
    items: [],
    currentPage: 1,
    lastPage: 1,
    total: 0,
  );

  test('should return PaginatedPrescriptionsEntity when repository succeeds', () async {
    when(() => mockRepository.getPrescriptions(
          search: 'Panadol',
          isPrinted: true,
        )).thenAnswer((_) async => const Right(tPaginated));

    final result = await useCase(search: 'Panadol', isPrinted: true);

    expect(result, const Right(tPaginated));
    verify(() => mockRepository.getPrescriptions(
          search: 'Panadol',
          isPrinted: true,
        )).called(1);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.getPrescriptions())
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));

    final result = await useCase();

    expect(result, const Left(ServerFailure(message: 'Error')));
  });
}
