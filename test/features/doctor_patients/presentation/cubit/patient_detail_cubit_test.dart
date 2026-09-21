import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_detail_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_profile_info_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_stats_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/use_cases/get_patient_detail_use_case.dart';
import 'package:medical_erp/features/doctor_patients/presentation/cubit/patient_detail_cubit.dart';
import 'package:medical_erp/features/doctor_patients/presentation/cubit/patient_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPatientDetailUseCase extends Mock
    implements GetPatientDetailUseCase {}

void main() {
  late PatientDetailCubit cubit;
  late MockGetPatientDetailUseCase mockUseCase;

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
    mockUseCase = MockGetPatientDetailUseCase();
    cubit = PatientDetailCubit(getPatientDetailUseCase: mockUseCase);
  });

  tearDown(() => cubit.close());

  test('initial state should be PatientDetailInitial', () {
    expect(cubit.state, const PatientDetailInitial());
  });

  blocTest<PatientDetailCubit, PatientDetailState>(
    'loadPatientDetail emits [Loading, Loaded] on success',
    build: () {
      when(() => mockUseCase(1)).thenAnswer((_) async => const Right(tDetail));
      return cubit;
    },
    act: (c) => c.loadPatientDetail(1),
    expect: () => [
      const PatientDetailLoading(),
      const PatientDetailLoaded(tDetail),
    ],
  );

  blocTest<PatientDetailCubit, PatientDetailState>(
    'loadPatientDetail emits [Loading, Error] on failure',
    build: () {
      when(() => mockUseCase(1)).thenAnswer((_) async => const Left(NotFoundFailure()));
      return cubit;
    },
    act: (c) => c.loadPatientDetail(1),
    expect: () => [
      const PatientDetailLoading(),
      const PatientDetailError(NotFoundFailure()),
    ],
  );
}
