import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_detail_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_profile_info_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_stats_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/repositories/doctor_patients_repository.dart';
import 'package:medical_erp/features/doctor_patients/domain/use_cases/get_patient_detail_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorPatientsRepository extends Mock
    implements DoctorPatientsRepository {}

void main() {
  late GetPatientDetailUseCase useCase;
  late MockDoctorPatientsRepository mockRepository;

  const tDetail = PatientDetailEntity(
    patient: PatientProfileInfoEntity(
      id: 1,
      name: 'سارة خالد',
      code: 'P-1001',
    ),
    stats: PatientStatsEntity(
      visitsCount: 3,
      prescriptionsCount: 1,
    ),
    visits: [],
  );

  setUp(() {
    mockRepository = MockDoctorPatientsRepository();
    useCase = GetPatientDetailUseCase(mockRepository);
  });

  test('should return PatientDetailEntity when repository succeeds', () async {
    when(() => mockRepository.getPatientDetail(1))
        .thenAnswer((_) async => const Right(tDetail));

    final result = await useCase(1);

    expect(result, const Right(tDetail));
    verify(() => mockRepository.getPatientDetail(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.getPatientDetail(1))
        .thenAnswer((_) async => const Left(NotFoundFailure()));

    final result = await useCase(1);

    expect(result, const Left(NotFoundFailure()));
    verify(() => mockRepository.getPatientDetail(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
