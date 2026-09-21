import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/domain/entities/paginated_prescriptions_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_patient_entity.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/delete_prescription_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/get_prescriptions_use_case.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_list_cubit.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPrescriptionsUseCase extends Mock implements GetPrescriptionsUseCase {}
class MockDeletePrescriptionUseCase extends Mock implements DeletePrescriptionUseCase {}

void main() {
  late PrescriptionListCubit cubit;
  late MockGetPrescriptionsUseCase mockGetPrescriptionsUseCase;
  late MockDeletePrescriptionUseCase mockDeletePrescriptionUseCase;

  const tRx = PrescriptionEntity(
    id: 1,
    prescriptionNumber: 'RX-1',
    patient: PrescriptionPatientEntity(id: 10, fullName: 'أحمد'),
  );

  const tPaginatedLoaded = PaginatedPrescriptionsEntity(
    items: [tRx],
    currentPage: 1,
    lastPage: 2,
    total: 2,
  );

  const tPaginatedEmpty = PaginatedPrescriptionsEntity(
    items: [],
    currentPage: 1,
    lastPage: 1,
    total: 0,
  );

  setUp(() {
    mockGetPrescriptionsUseCase = MockGetPrescriptionsUseCase();
    mockDeletePrescriptionUseCase = MockDeletePrescriptionUseCase();
    cubit = PrescriptionListCubit(
      getPrescriptionsUseCase: mockGetPrescriptionsUseCase,
      deletePrescriptionUseCase: mockDeletePrescriptionUseCase,
    );
  });

  tearDown(() => cubit.close());

  test('initial state should be PrescriptionListInitial', () {
    expect(cubit.state, const PrescriptionListInitial());
  });

  blocTest<PrescriptionListCubit, PrescriptionListState>(
    'loadPrescriptions emits [Loading, Loaded] when items exist',
    build: () {
      when(() => mockGetPrescriptionsUseCase()).thenAnswer((_) async => const Right(tPaginatedLoaded));
      return cubit;
    },
    act: (c) => c.loadPrescriptions(),
    expect: () => [
      const PrescriptionListLoading(),
      const PrescriptionListLoaded(
        items: [tRx],
        currentPage: 1,
        lastPage: 2,
        total: 2,
        hasMore: true,
      ),
    ],
  );

  blocTest<PrescriptionListCubit, PrescriptionListState>(
    'loadPrescriptions emits [Loading, Empty] when list is empty',
    build: () {
      when(() => mockGetPrescriptionsUseCase()).thenAnswer((_) async => const Right(tPaginatedEmpty));
      return cubit;
    },
    act: (c) => c.loadPrescriptions(),
    expect: () => [
      const PrescriptionListLoading(),
      const PrescriptionListEmpty(),
    ],
  );

  blocTest<PrescriptionListCubit, PrescriptionListState>(
    'loadPrescriptions emits [Loading, Error] when use case fails',
    build: () {
      when(() => mockGetPrescriptionsUseCase())
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
      return cubit;
    },
    act: (c) => c.loadPrescriptions(),
    expect: () => [
      const PrescriptionListLoading(),
      const PrescriptionListError(ServerFailure(message: 'Error')),
    ],
  );

  blocTest<PrescriptionListCubit, PrescriptionListState>(
    'deletePrescription removes item from loaded state and emits Empty if 0 left',
    build: () {
      when(() => mockDeletePrescriptionUseCase(1))
          .thenAnswer((_) async => const Right(null));
      return cubit;
    },
    seed: () => const PrescriptionListLoaded(
      items: [tRx],
      currentPage: 1,
      lastPage: 1,
      total: 1,
    ),
    act: (c) => c.deletePrescription(1),
    expect: () => [
      const PrescriptionListEmpty(),
    ],
  );
}
