import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_list_result_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/entities/patient_summary_entity.dart';
import 'package:medical_erp/features/doctor_patients/domain/use_cases/get_doctor_patients_use_case.dart';
import 'package:medical_erp/features/doctor_patients/presentation/cubit/patient_list_cubit.dart';
import 'package:medical_erp/features/doctor_patients/presentation/cubit/patient_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorPatientsUseCase extends Mock
    implements GetDoctorPatientsUseCase {}

void main() {
  late PatientListCubit cubit;
  late MockGetDoctorPatientsUseCase mockUseCase;

  const tPatient = PatientSummaryEntity(
    id: 1,
    name: 'سارة خالد',
    code: 'P-1001',
    totalVisits: 3,
  );

  const tLoadedResult = PatientListResultEntity(
    items: [tPatient],
    total: 1,
    currentPage: 1,
    lastPage: 1,
  );

  const tEmptyResult = PatientListResultEntity(
    items: [],
    total: 0,
    currentPage: 1,
    lastPage: 1,
  );

  setUp(() {
    mockUseCase = MockGetDoctorPatientsUseCase();
    cubit = PatientListCubit(getDoctorPatientsUseCase: mockUseCase);
  });

  tearDown(() => cubit.close());

  test('initial state should be PatientListInitial', () {
    expect(cubit.state, const PatientListInitial());
  });

  blocTest<PatientListCubit, PatientListState>(
    'loadPatients emits [Loading, Loaded] when items exist',
    build: () {
      when(() => mockUseCase(search: any(named: 'search'), page: any(named: 'page')))
          .thenAnswer((_) async => const Right(tLoadedResult));
      return cubit;
    },
    act: (c) => c.loadPatients(),
    expect: () => [
      const PatientListLoading(),
      const PatientListLoaded(
        items: [tPatient],
        currentPage: 1,
        lastPage: 1,
        total: 1,
      ),
    ],
  );

  blocTest<PatientListCubit, PatientListState>(
    'loadPatients emits [Loading, Empty] when list is empty',
    build: () {
      when(() => mockUseCase(search: any(named: 'search'), page: any(named: 'page')))
          .thenAnswer((_) async => const Right(tEmptyResult));
      return cubit;
    },
    act: (c) => c.loadPatients(),
    expect: () => [
      const PatientListLoading(),
      const PatientListEmpty(),
    ],
  );

  blocTest<PatientListCubit, PatientListState>(
    'loadPatients emits [Loading, Error] when use case fails',
    build: () {
      when(() => mockUseCase(search: any(named: 'search'), page: any(named: 'page')))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'error')));
      return cubit;
    },
    act: (c) => c.loadPatients(),
    expect: () => [
      const PatientListLoading(),
      const PatientListError(ServerFailure(message: 'error')),
    ],
  );
}
