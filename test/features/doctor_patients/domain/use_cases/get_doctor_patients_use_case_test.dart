import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_list_result_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_summary_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/repositories/doctor_patients_repository.dart';
import 'package:medical_erp/features/doctor_patients/domain/use_cases/get_doctor_patients_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorPatientsRepository extends Mock
    implements DoctorPatientsRepository {}

void main() {
  late GetDoctorPatientsUseCase useCase;
  late MockDoctorPatientsRepository mockRepository;

  const tPatient = PatientSummaryEntity(
    id: 1,
    name: 'سارة خالد',
    code: 'P-1001',
    totalVisits: 3,
  );

  const tResult = PatientListResultEntity(
    items: [tPatient],
    total: 1,
    currentPage: 1,
    lastPage: 1,
  );

  setUp(() {
    mockRepository = MockDoctorPatientsRepository();
    useCase = GetDoctorPatientsUseCase(mockRepository);
  });

  test('should return PatientListResultEntity when repository succeeds', () async {
    when(() => mockRepository.getPatients(search: any(named: 'search'), page: any(named: 'page')))
        .thenAnswer((_) async => const Right(tResult));

    final result = await useCase();

    expect(result, const Right(tResult));
    verify(() => mockRepository.getPatients()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.getPatients(search: any(named: 'search'), page: any(named: 'page')))
        .thenAnswer((_) async => const Left(ServerFailure(message: 'server error')));

    final result = await useCase(search: 'سارة', page: 2);

    expect(result, const Left(ServerFailure(message: 'server error')));
    verify(() => mockRepository.getPatients(search: 'سارة', page: 2)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
