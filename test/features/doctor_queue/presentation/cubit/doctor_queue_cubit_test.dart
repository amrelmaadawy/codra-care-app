import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/doctor_queue_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/queue_patient_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/queue_summary_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/call_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/cancel_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/complete_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/get_doctor_queue_use_case.dart';
import 'package:medical_erp/features/doctor_queue/presentation/cubit/doctor_queue_cubit.dart';
import 'package:medical_erp/features/doctor_queue/presentation/cubit/doctor_queue_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetDoctorQueueUseCase extends Mock implements GetDoctorQueueUseCase {}
class MockCallPatientUseCase extends Mock implements CallPatientUseCase {}
class MockCompletePatientUseCase extends Mock implements CompletePatientUseCase {}
class MockCancelPatientUseCase extends Mock implements CancelPatientUseCase {}

void main() {
  late DoctorQueueCubit cubit;
  late MockGetDoctorQueueUseCase mockGetQueueUseCase;
  late MockCallPatientUseCase mockCallPatientUseCase;
  late MockCompletePatientUseCase mockCompletePatientUseCase;
  late MockCancelPatientUseCase mockCancelPatientUseCase;

  setUp(() {
    mockGetQueueUseCase = MockGetDoctorQueueUseCase();
    mockCallPatientUseCase = MockCallPatientUseCase();
    mockCompletePatientUseCase = MockCompletePatientUseCase();
    mockCancelPatientUseCase = MockCancelPatientUseCase();

    cubit = DoctorQueueCubit(
      getQueueUseCase: mockGetQueueUseCase,
      callPatientUseCase: mockCallPatientUseCase,
      completePatientUseCase: mockCompletePatientUseCase,
      cancelPatientUseCase: mockCancelPatientUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tPatient = QueuePatientEntity(
    id: 1,
    ticketNumber: 'A-01',
    patientName: 'أحمد علي',
    serviceName: 'كشف عام',
    priority: 'urgent',
    status: 'waiting',
    isUrgent: true,
    isVip: false,
    hasIntakeVitals: false,
  );

  const tSummary = QueueSummaryEntity(
    completedToday: 2,
    waitingCount: 1,
    withDoctorCount: 0,
    totalActive: 1,
    urgentCount: 1,
    hasUrgent: true,
  );

  const tQueue = DoctorQueueEntity(
    items: [tPatient],
    summary: tSummary,
  );

  test('initial state should be DoctorQueueInitial', () {
    expect(cubit.state, const DoctorQueueInitial());
  });

  group('loadQueue', () {
    blocTest<DoctorQueueCubit, DoctorQueueState>(
      'emits [DoctorQueueLoading, DoctorQueueLoaded] when getQueue succeeds',
      build: () {
        when(() => mockGetQueueUseCase()).thenAnswer((_) async => const Right(tQueue));
        return cubit;
      },
      act: (cubit) => cubit.loadQueue(),
      expect: () => [
        const DoctorQueueLoading(),
        const DoctorQueueLoaded(queue: tQueue),
      ],
    );

    blocTest<DoctorQueueCubit, DoctorQueueState>(
      'emits [DoctorQueueLoading, DoctorQueueError] when getQueue fails',
      build: () {
        const tFailure = ServerFailure(message: 'Server error');
        when(() => mockGetQueueUseCase()).thenAnswer((_) async => const Left(tFailure));
        return cubit;
      },
      act: (cubit) => cubit.loadQueue(),
      expect: () => [
        const DoctorQueueLoading(),
        const DoctorQueueError('Server error'),
      ],
    );
  });

  group('callPatient', () {
    blocTest<DoctorQueueCubit, DoctorQueueState>(
      'emits action loading then success message and triggers silentRefresh',
      build: () {
        when(() => mockCallPatientUseCase(1)).thenAnswer((_) async => const Right(null));
        when(() => mockGetQueueUseCase()).thenAnswer((_) async => const Right(tQueue));
        return cubit;
      },
      seed: () => const DoctorQueueLoaded(queue: tQueue),
      act: (cubit) => cubit.callPatient(1),
      expect: () => [
        const DoctorQueueLoaded(
          queue: tQueue,
          activeActionItemId: 1,
          activeAction: QueueAction.call,
        ),
        const DoctorQueueLoaded(
          queue: tQueue,
          successMessage: 'doctor_queue.call_success',
        ),
        const DoctorQueueLoaded(
          queue: tQueue,
        ),
      ],
    );
  });

  group('setFilter', () {
    blocTest<DoctorQueueCubit, DoctorQueueState>(
      'updates selectedFilter when a new filter is selected',
      build: () => cubit,
      seed: () => const DoctorQueueLoaded(queue: tQueue),
      act: (cubit) => cubit.setFilter(QueueFilter.waiting),
      expect: () => [
        const DoctorQueueLoaded(
          queue: tQueue,
          selectedFilter: QueueFilter.waiting,
        ),
      ],
    );

    blocTest<DoctorQueueCubit, DoctorQueueState>(
      'toggles back to QueueFilter.all when the same filter is clicked again',
      build: () => cubit,
      seed: () => const DoctorQueueLoaded(
        queue: tQueue,
        selectedFilter: QueueFilter.waiting,
      ),
      act: (cubit) => cubit.setFilter(QueueFilter.waiting),
      expect: () => [
        const DoctorQueueLoaded(
          queue: tQueue,
        ),
      ],
    );
  });
}
