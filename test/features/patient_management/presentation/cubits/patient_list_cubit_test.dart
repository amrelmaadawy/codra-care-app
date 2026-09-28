import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failure_mapper.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_list_entity.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_list_query.dart';
import 'package:medical_erp/features/patient_management/domain/entities/patient_page_entity.dart';
import 'package:medical_erp/features/patient_management/domain/use_cases/get_patients_use_case.dart';
import 'package:medical_erp/features/patient_management/presentation/cubits/patient_list_cubit.dart';
import 'package:medical_erp/features/patient_management/presentation/cubits/patient_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPatientsUseCase extends Mock implements GetPatientsUseCase {}

void main() {
  late PatientListCubit cubit;
  late MockGetPatientsUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const PatientListQuery());
  });

  const tQuery1 = PatientListQuery();
  const tQuery2 = PatientListQuery(page: 2);

  const tPatient1 = PatientListEntity(
    id: 1,
    code: 'P-1',
    name: 'مريض أول',
    phone: '010',
    gender: 'male',
    age: 20,
  );

  const tPatient2 = PatientListEntity(
    id: 2,
    code: 'P-2',
    name: 'مريض ثان',
    phone: '011',
    gender: 'female',
    age: 30,
  );

  const tLoadedPage = PatientPageEntity(
    items: [tPatient1],
    currentPage: 1,
    lastPage: 2,
    perPage: 20,
    total: 2,
    hasMore: true,
  );

  const tEmptyPage = PatientPageEntity(
    items: [],
    currentPage: 1,
    lastPage: 1,
    perPage: 20,
    total: 0,
    hasMore: false,
  );

  setUp(() {
    mockUseCase = MockGetPatientsUseCase();
    cubit = PatientListCubit(getPatientsUseCase: mockUseCase);
  });

  tearDown(() => cubit.close());

  test('initial state should be PatientListInitial', () {
    expect(cubit.state, const PatientListInitial());
  });

  blocTest<PatientListCubit, PatientListState>(
    'loadInitial emits [Loading, Success] when items returned',
    build: () {
      when(
        () => mockUseCase(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right(tLoadedPage));
      return cubit;
    },
    act: (c) => c.loadInitial(),
    expect: () => [
      const PatientListLoading(query: tQuery1),
      const PatientListSuccess(
        items: [tPatient1],
        query: tQuery1,
        hasMore: true,
        total: 2,
      ),
    ],
  );

  blocTest<PatientListCubit, PatientListState>(
    'loadInitial emits [Loading, Empty] when items are empty',
    build: () {
      when(
        () => mockUseCase(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right(tEmptyPage));
      return cubit;
    },
    act: (c) => c.loadInitial(),
    expect: () => [
      const PatientListLoading(query: tQuery1),
      const PatientListEmpty(query: tQuery1, isClinicEmpty: true),
    ],
  );

  blocTest<PatientListCubit, PatientListState>(
    'loadInitial emits [Loading, Error] on failure',
    build: () {
      when(
        () => mockUseCase(any(), cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
      return cubit;
    },
    act: (c) => c.loadInitial(),
    expect: () => [
      const PatientListLoading(query: tQuery1),
      PatientListError(
        query: tQuery1,
        message: FailureMapper.mapFailureToMessage(
          const ServerFailure(message: 'Error'),
        ),
        failure: const ServerFailure(message: 'Error'),
      ),
    ],
  );

  blocTest<PatientListCubit, PatientListState>(
    'loadMore appends unique items to list',
    build: () {
      when(
        () => mockUseCase(tQuery1, cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => const Right(tLoadedPage));
      when(
        () => mockUseCase(tQuery2, cancelToken: any(named: 'cancelToken')),
      ).thenAnswer(
        (_) async => const Right(
          PatientPageEntity(
            items: [tPatient2],
            currentPage: 2,
            lastPage: 2,
            perPage: 20,
            total: 2,
            hasMore: false,
          ),
        ),
      );
      return cubit;
    },
    act: (c) async {
      await c.loadInitial();
      await c.loadMore();
    },
    expect: () => [
      const PatientListLoading(query: tQuery1),
      const PatientListSuccess(
        items: [tPatient1],
        query: tQuery1,
        hasMore: true,
        total: 2,
      ),
      const PatientListSuccess(
        items: [tPatient1],
        query: tQuery1,
        hasMore: true,
        total: 2,
        isPaginating: true,
      ),
      const PatientListSuccess(
        items: [tPatient1, tPatient2],
        query: tQuery2,
        hasMore: false,
        total: 2,
      ),
    ],
  );
}
