import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_list_entity.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_list_query.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_page_entity.dart';
import 'package:medical_erp/features/patient_management/domain/repositories/patient_repository.dart';
import 'package:medical_erp/features/patient_management/domain/use_cases/get_patients_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockPatientRepository extends Mock implements PatientRepository {}

void main() {
  late GetPatientsUseCase useCase;
  late MockPatientRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const PatientListQuery());
  });

  setUp(() {
    mockRepository = MockPatientRepository();
    useCase = GetPatientsUseCase(mockRepository);
  });

  const tQuery = PatientListQuery(search: 'أحمد');
  const tPatient = PatientListEntity(
    id: 1,
    code: 'P-001',
    name: 'أحمد',
    phone: '010',
    gender: 'male',
    age: 30,
  );
  const tPage = PatientPageEntity(
    items: [tPatient],
    currentPage: 1,
    lastPage: 1,
    perPage: 20,
    total: 1,
    hasMore: false,
  );

  test(
    'should return PatientPageEntity when repository call succeeds',
    () async {
      when(
        () => mockRepository.getPatients(any()),
      ).thenAnswer((_) async => const Right(tPage));

      final result = await useCase(tQuery);

      expect(result, const Right(tPage));
      verify(() => mockRepository.getPatients(tQuery)).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should return Failure when repository call fails', () async {
    const tFailure = ServerFailure(message: 'Server error');
    when(
      () => mockRepository.getPatients(any()),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(tQuery);

    expect(result, const Left(tFailure));
    verify(() => mockRepository.getPatients(tQuery)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
