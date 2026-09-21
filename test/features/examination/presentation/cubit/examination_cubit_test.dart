import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/examination/domain/entities/examination_entity.dart';
import 'package:medical_erp/features/examination/domain/entities/visit_patient_entity.dart';
import 'package:medical_erp/features/examination/domain/use_cases/complete_examination_use_case.dart';
import 'package:medical_erp/features/examination/domain/use_cases/copy_previous_visit_use_case.dart';
import 'package:medical_erp/features/examination/domain/use_cases/delete_file_use_case.dart';
import 'package:medical_erp/features/examination/domain/use_cases/get_examination_use_case.dart';
import 'package:medical_erp/features/examination/domain/use_cases/save_section_use_case.dart';
import 'package:medical_erp/features/examination/domain/use_cases/upload_files_use_case.dart';
import 'package:medical_erp/features/examination/presentation/cubit/examination_cubit.dart';
import 'package:medical_erp/features/examination/presentation/cubit/examination_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetExaminationUseCase extends Mock implements GetExaminationUseCase {}
class MockSaveSectionUseCase extends Mock implements SaveSectionUseCase {}
class MockUploadFilesUseCase extends Mock implements UploadFilesUseCase {}
class MockDeleteFileUseCase extends Mock implements DeleteFileUseCase {}
class MockCompleteExaminationUseCase extends Mock implements CompleteExaminationUseCase {}
class MockCopyPreviousVisitUseCase extends Mock implements CopyPreviousVisitUseCase {}

void main() {
  late ExaminationCubit cubit;
  late MockGetExaminationUseCase mockGetExaminationUseCase;
  late MockSaveSectionUseCase mockSaveSectionUseCase;
  late MockUploadFilesUseCase mockUploadFilesUseCase;
  late MockDeleteFileUseCase mockDeleteFileUseCase;
  late MockCompleteExaminationUseCase mockCompleteExaminationUseCase;
  late MockCopyPreviousVisitUseCase mockCopyPreviousVisitUseCase;

  const tVisitId = 10;
  const tPatient = VisitPatientEntity(id: 1, name: 'سارة خالد');
  const tEntity = ExaminationEntity(
    id: tVisitId,
    visitNumber: 'VST-100',
    status: 'in_progress',
    patient: tPatient,
    chiefComplaint: 'صداع',
    diagnosis: 'إرهاق',
  );

  setUp(() {
    mockGetExaminationUseCase = MockGetExaminationUseCase();
    mockSaveSectionUseCase = MockSaveSectionUseCase();
    mockUploadFilesUseCase = MockUploadFilesUseCase();
    mockDeleteFileUseCase = MockDeleteFileUseCase();
    mockCompleteExaminationUseCase = MockCompleteExaminationUseCase();
    mockCopyPreviousVisitUseCase = MockCopyPreviousVisitUseCase();

    cubit = ExaminationCubit(
      visitId: tVisitId,
      getExaminationUseCase: mockGetExaminationUseCase,
      saveSectionUseCase: mockSaveSectionUseCase,
      uploadFilesUseCase: mockUploadFilesUseCase,
      deleteFileUseCase: mockDeleteFileUseCase,
      completeExaminationUseCase: mockCompleteExaminationUseCase,
      copyPreviousVisitUseCase: mockCopyPreviousVisitUseCase,
    );
  });

  tearDown(() => cubit.close());

  test('initial state is ExaminationInitial', () {
    expect(cubit.state, const ExaminationInitial());
  });

  group('loadExamination', () {
    blocTest<ExaminationCubit, ExaminationState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockGetExaminationUseCase(tVisitId))
            .thenAnswer((_) async => const Right(tEntity));
        return cubit;
      },
      act: (c) => c.loadExamination(),
      expect: () => [
        const ExaminationLoading(),
        const ExaminationLoaded(visit: tEntity),
      ],
    );

    blocTest<ExaminationCubit, ExaminationState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockGetExaminationUseCase(tVisitId))
            .thenAnswer((_) async => const Left(ServerFailure(message: 'Failed')));
        return cubit;
      },
      act: (c) => c.loadExamination(),
      expect: () => [
        const ExaminationLoading(),
        const ExaminationError('Failed'),
      ],
    );
  });

  group('completeExamination', () {
    blocTest<ExaminationCubit, ExaminationState>(
      'emits validation error if complaint is empty',
      build: () => cubit,
      seed: () => const ExaminationLoaded(visit: tEntity),
      act: (c) => c.completeExamination({'chief_complaint': '', 'diagnosis': 'كحة'}),
      expect: () => [
        isA<ExaminationLoaded>().having(
          (s) => s.errorMessage,
          'errorMessage',
          'examination.validation_complaint_required',
        ),
      ],
    );

    blocTest<ExaminationCubit, ExaminationState>(
      'emits [isCompleting, isCompleted] on success',
      build: () {
        when(() => mockCompleteExaminationUseCase(
              visitId: tVisitId,
              data: any(named: 'data'),
            )).thenAnswer((_) async => const Right(null));
        return cubit;
      },
      seed: () => const ExaminationLoaded(visit: tEntity),
      act: (c) => c.completeExamination({
        'chief_complaint': 'صداع شديد',
        'diagnosis': 'صداع نصفي',
      }),
      expect: () => [
        isA<ExaminationLoaded>().having((s) => s.isCompleting, 'isCompleting', true),
        isA<ExaminationLoaded>().having((s) => s.isCompleted, 'isCompleted', true),
      ],
    );
  });

  group('copyPreviousVisit', () {
    blocTest<ExaminationCubit, ExaminationState>(
      'updates visit data and shows success message',
      build: () {
        when(() => mockCopyPreviousVisitUseCase(
              visitId: tVisitId,
              prevId: 5,
            )).thenAnswer((_) async => const Right({
              'chief_complaint': 'شكوى منسوخة',
              'diagnosis': 'تشخيص منسوخ',
              'notes': 'ملاحظة منسوخة',
            }));
        return cubit;
      },
      seed: () => const ExaminationLoaded(visit: tEntity),
      act: (c) => c.copyPreviousVisit(5),
      expect: () => [
        isA<ExaminationLoaded>()
            .having((s) => s.visit.chiefComplaint, 'complaint', 'شكوى منسوخة')
            .having((s) => s.visit.diagnosis, 'diagnosis', 'تشخيص منسوخ'),
      ],
    );
  });
}
