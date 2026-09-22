import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/entities/diagnosis_template_entity.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/entities/paginated_diagnosis_templates_entity.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/use_cases/create_diagnosis_template_use_case.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/use_cases/delete_diagnosis_template_use_case.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/use_cases/get_diagnosis_templates_use_case.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/use_cases/update_diagnosis_template_use_case.dart';
import 'package:medical_erp/features/diagnosis_templates/domain/use_cases/use_diagnosis_template_use_case.dart';
import 'package:medical_erp/features/diagnosis_templates/presentation/cubit/diagnosis_template_list_cubit.dart';
import 'package:medical_erp/features/diagnosis_templates/presentation/cubit/diagnosis_template_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDiagnosisTemplatesUseCase extends Mock
    implements GetDiagnosisTemplatesUseCase {}

class MockCreateDiagnosisTemplateUseCase extends Mock
    implements CreateDiagnosisTemplateUseCase {}

class MockUpdateDiagnosisTemplateUseCase extends Mock
    implements UpdateDiagnosisTemplateUseCase {}

class MockDeleteDiagnosisTemplateUseCase extends Mock
    implements DeleteDiagnosisTemplateUseCase {}

class MockUseDiagnosisTemplateUseCase extends Mock
    implements UseDiagnosisTemplateUseCase {}

void main() {
  late DiagnosisTemplateListCubit cubit;
  late MockGetDiagnosisTemplatesUseCase mockGet;
  late MockCreateDiagnosisTemplateUseCase mockCreate;
  late MockUpdateDiagnosisTemplateUseCase mockUpdate;
  late MockDeleteDiagnosisTemplateUseCase mockDelete;
  late MockUseDiagnosisTemplateUseCase mockUse;

  const tTemplate = DiagnosisTemplateEntity(
    id: 1,
    doctorId: 4,
    title: 'التهاب حاد بالحلق',
    chiefComplaint: 'ألم في الحلق وصعوبة في البلع',
    diagnosis: 'Acute Pharyngitis',
    notes: 'راحة وتناول السوائل الدافئة',
    usageCount: 3,
  );

  const tPaginated = PaginatedDiagnosisTemplatesEntity(
    items: [tTemplate],
    currentPage: 1,
    lastPage: 1,
    total: 1,
  );

  const tEmptyPaginated = PaginatedDiagnosisTemplatesEntity(
    items: [],
    currentPage: 1,
    lastPage: 1,
    total: 0,
  );

  setUp(() {
    mockGet = MockGetDiagnosisTemplatesUseCase();
    mockCreate = MockCreateDiagnosisTemplateUseCase();
    mockUpdate = MockUpdateDiagnosisTemplateUseCase();
    mockDelete = MockDeleteDiagnosisTemplateUseCase();
    mockUse = MockUseDiagnosisTemplateUseCase();

    cubit = DiagnosisTemplateListCubit(
      getTemplatesUseCase: mockGet,
      createTemplateUseCase: mockCreate,
      updateTemplateUseCase: mockUpdate,
      deleteTemplateUseCase: mockDelete,
      useTemplateUseCase: mockUse,
    );
  });

  tearDown(() => cubit.close());

  test('initial state should be DiagnosisTemplateListInitial', () {
    expect(cubit.state, const DiagnosisTemplateListInitial());
  });

  blocTest<DiagnosisTemplateListCubit, DiagnosisTemplateListState>(
    'loadTemplates emits [Loading, Loaded] when items exist',
    build: () {
      when(() => mockGet(search: any(named: 'search')))
          .thenAnswer((_) async => const Right(tPaginated));
      return cubit;
    },
    act: (c) => c.loadTemplates(),
    expect: () => [
      const DiagnosisTemplateListLoading(),
      isA<DiagnosisTemplateListLoaded>()
          .having((s) => s.items.length, 'items count', 1)
          .having((s) => s.total, 'total', 1),
    ],
  );

  blocTest<DiagnosisTemplateListCubit, DiagnosisTemplateListState>(
    'loadTemplates emits [Loading, Empty] when no items',
    build: () {
      when(() => mockGet(search: any(named: 'search')))
          .thenAnswer((_) async => const Right(tEmptyPaginated));
      return cubit;
    },
    act: (c) => c.loadTemplates(),
    expect: () => [
      const DiagnosisTemplateListLoading(),
      isA<DiagnosisTemplateListEmpty>(),
    ],
  );

  blocTest<DiagnosisTemplateListCubit, DiagnosisTemplateListState>(
    'loadTemplates emits [Loading, Error] on failure',
    build: () {
      when(() => mockGet(search: any(named: 'search')))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'error')));
      return cubit;
    },
    act: (c) => c.loadTemplates(),
    expect: () => [
      const DiagnosisTemplateListLoading(),
      isA<DiagnosisTemplateListError>(),
    ],
  );

  blocTest<DiagnosisTemplateListCubit, DiagnosisTemplateListState>(
    'setFilter changes selectedFilter',
    build: () => cubit,
    seed: () => const DiagnosisTemplateListLoaded(
      items: [tTemplate],
      currentPage: 1,
      lastPage: 1,
      total: 1,
    ),
    act: (c) => c.setFilter(DiagnosisTemplateFilterChip.topUsed),
    expect: () => [
      isA<DiagnosisTemplateListLoaded>().having(
        (s) => s.selectedFilter,
        'filter',
        DiagnosisTemplateFilterChip.topUsed,
      ),
    ],
  );
}
