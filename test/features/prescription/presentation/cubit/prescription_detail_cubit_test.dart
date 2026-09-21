import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_patient_entity.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/get_prescription_detail_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/mark_printed_use_case.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_detail_cubit.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_detail_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPrescriptionDetailUseCase extends Mock
    implements GetPrescriptionDetailUseCase {}

class MockMarkPrintedUseCase extends Mock implements MarkPrintedUseCase {}

void main() {
  late PrescriptionDetailCubit cubit;
  late MockGetPrescriptionDetailUseCase mockGetPrescriptionDetailUseCase;
  late MockMarkPrintedUseCase mockMarkPrintedUseCase;

  const tRx = PrescriptionEntity(
    id: 1,
    prescriptionNumber: 'RX-1',
    patient: PrescriptionPatientEntity(id: 10, fullName: 'أحمد'),
  );

  setUp(() {
    mockGetPrescriptionDetailUseCase = MockGetPrescriptionDetailUseCase();
    mockMarkPrintedUseCase = MockMarkPrintedUseCase();
    cubit = PrescriptionDetailCubit(
      getPrescriptionDetailUseCase: mockGetPrescriptionDetailUseCase,
      markPrintedUseCase: mockMarkPrintedUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be PrescriptionDetailInitial', () {
    expect(cubit.state, const PrescriptionDetailInitial());
  });

  blocTest<PrescriptionDetailCubit, PrescriptionDetailState>(
    'loadPrescription emits [Loading, Loaded] when successful',
    build: () {
      when(() => mockGetPrescriptionDetailUseCase(1))
          .thenAnswer((_) async => const Right(tRx));
      return cubit;
    },
    act: (cubit) => cubit.loadPrescription(1),
    expect: () => [
      const PrescriptionDetailLoading(),
      const PrescriptionDetailLoaded(tRx),
    ],
  );

  blocTest<PrescriptionDetailCubit, PrescriptionDetailState>(
    'loadPrescription emits [Loading, Error] when failure',
    build: () {
      when(() => mockGetPrescriptionDetailUseCase(1))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Error')));
      return cubit;
    },
    act: (cubit) => cubit.loadPrescription(1),
    expect: () => [
      const PrescriptionDetailLoading(),
      const PrescriptionDetailError(ServerFailure(message: 'Error')),
    ],
  );

  blocTest<PrescriptionDetailCubit, PrescriptionDetailState>(
    'markPrinted updates isPrinted to true when in loaded state and succeeds',
    build: () {
      when(() => mockMarkPrintedUseCase(1))
          .thenAnswer((_) async => const Right(null));
      return cubit;
    },
    seed: () => const PrescriptionDetailLoaded(tRx),
    act: (cubit) => cubit.markPrinted(1),
    verify: (_) {
      verify(() => mockMarkPrintedUseCase(1)).called(1);
    },
    expect: () => [
      predicate<PrescriptionDetailState>((state) {
        if (state is PrescriptionDetailLoaded) {
          return state.prescription.isPrinted == true;
        }
        return false;
      }),
    ],
  );
}
