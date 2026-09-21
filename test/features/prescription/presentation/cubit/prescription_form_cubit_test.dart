import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_context_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_patient_entity.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/copy_prescription_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/create_prescription_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/get_prescription_context_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/get_prescription_detail_use_case.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/update_prescription_use_case.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/drug_item_draft.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_form_cubit.dart';
import 'package:medical_erp/features/prescription/presentation/cubit/prescription_form_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPrescriptionContextUseCase extends Mock
    implements GetPrescriptionContextUseCase {}
class MockGetPrescriptionDetailUseCase extends Mock
    implements GetPrescriptionDetailUseCase {}
class MockCreatePrescriptionUseCase extends Mock
    implements CreatePrescriptionUseCase {}
class MockUpdatePrescriptionUseCase extends Mock
    implements UpdatePrescriptionUseCase {}
class MockCopyPrescriptionUseCase extends Mock
    implements CopyPrescriptionUseCase {}

void main() {
  late PrescriptionFormCubit cubit;
  late MockGetPrescriptionContextUseCase mockGetContext;
  late MockGetPrescriptionDetailUseCase mockGetDetail;
  late MockCreatePrescriptionUseCase mockCreate;
  late MockUpdatePrescriptionUseCase mockUpdate;
  late MockCopyPrescriptionUseCase mockCopy;

  const tPatient = PrescriptionPatientEntity(id: 1, fullName: 'أحمد سعيد');
  const tContext = PrescriptionContextEntity(patient: tPatient, visitId: 10);
  const tRx = PrescriptionEntity(
    id: 1,
    prescriptionNumber: 'RX-1',
    patient: tPatient,
  );

  setUp(() {
    mockGetContext = MockGetPrescriptionContextUseCase();
    mockGetDetail = MockGetPrescriptionDetailUseCase();
    mockCreate = MockCreatePrescriptionUseCase();
    mockUpdate = MockUpdatePrescriptionUseCase();
    mockCopy = MockCopyPrescriptionUseCase();

    cubit = PrescriptionFormCubit(
      getPrescriptionContextUseCase: mockGetContext,
      getPrescriptionDetailUseCase: mockGetDetail,
      createPrescriptionUseCase: mockCreate,
      updatePrescriptionUseCase: mockUpdate,
      copyPrescriptionUseCase: mockCopy,
    );
  });

  tearDown(() => cubit.close());

  test('initial state is PrescriptionFormInitial', () {
    expect(cubit.state, const PrescriptionFormInitial());
  });

  blocTest<PrescriptionFormCubit, PrescriptionFormState>(
    'initForm emits [Loading, Ready] when context succeeds',
    build: () {
      when(() => mockGetContext(visitId: 10, patientId: 1))
          .thenAnswer((_) async => const Right(tContext));
      return cubit;
    },
    act: (c) => c.initForm(visitId: 10, patientId: 1),
    expect: () => [
      const PrescriptionFormLoading(),
      predicate<PrescriptionFormState>((state) {
        if (state is! PrescriptionFormReady) return false;
        return state.selectedPatient?.id == 1 &&
            state.visitId == 10 &&
            state.items.length == 1;
      }),
    ],
  );

  test('addDrugItem appends a new draft item', () {
    cubit.emit(const PrescriptionFormReady(
      items: [DrugItemDraft(id: '1')],
      selectedPatient: tPatient,
      contextData: tContext,
    ));

    cubit.addDrugItem();

    final state = cubit.state as PrescriptionFormReady;
    expect(state.items.length, 2);
  });

  test('removeDrugItem does not remove when only 1 item exists', () {
    cubit.emit(const PrescriptionFormReady(
      items: [DrugItemDraft(id: '1')],
      selectedPatient: tPatient,
      contextData: tContext,
    ));

    cubit.removeDrugItem(0);

    final state = cubit.state as PrescriptionFormReady;
    expect(state.items.length, 1);
  });

  blocTest<PrescriptionFormCubit, PrescriptionFormState>(
    'submit validates patient and items before calling create',
    build: () => cubit,
    seed: () => const PrescriptionFormReady(
      items: [DrugItemDraft(id: '1')],
      contextData: tContext,
    ),
    act: (c) => c.submit(),
    expect: () => [
      const PrescriptionFormError('prescription.validation_patient'),
      const PrescriptionFormReady(
        items: [DrugItemDraft(id: '1')],
        contextData: tContext,
      ),
    ],
  );

  blocTest<PrescriptionFormCubit, PrescriptionFormState>(
    'submit creates prescription successfully when inputs are valid',
    build: () {
      when(() => mockCreate(
            patientId: 1,
            visitId: 10,
            items: any(named: 'items'),
          )).thenAnswer((_) async => const Right(tRx));
      return cubit;
    },
    seed: () => const PrescriptionFormReady(
      items: [
        DrugItemDraft(
          id: '1',
          drugName: 'Paracetamol',
          dosage: '500mg',
          frequency: 'TDS',
        ),
      ],
      selectedPatient: tPatient,
      visitId: 10,
      contextData: tContext,
    ),
    act: (c) => c.submit(),
    expect: () => [
      predicate<PrescriptionFormState>((s) => s is PrescriptionFormReady && s.isSubmitting),
      const PrescriptionFormSuccess(prescription: tRx, isEditing: false),
    ],
  );
}
