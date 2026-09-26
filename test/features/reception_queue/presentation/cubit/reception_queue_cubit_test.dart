import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/queue_capabilities_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/queue_filter.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/queue_summary_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/reception_queue_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/reception_queue_item_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/call_doctor_use_case.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/cancel_queue_item_use_case.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/complete_queue_item_use_case.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/get_reception_queue_use_case.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/toggle_presence_use_case.dart';
import 'package:medical_erp/features/reception_queue/presentation/cubit/reception_queue_cubit.dart';
import 'package:medical_erp/features/reception_queue/presentation/cubit/reception_queue_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetQueueUseCase extends Mock implements GetReceptionQueueUseCase {}
class MockTogglePresenceUseCase extends Mock implements TogglePresenceUseCase {}
class MockCallDoctorUseCase extends Mock implements CallDoctorUseCase {}
class MockCompleteUseCase extends Mock implements CompleteQueueItemUseCase {}
class MockCancelUseCase extends Mock implements CancelQueueItemUseCase {}

void main() {
  late MockGetQueueUseCase mockGetQueue;
  late MockTogglePresenceUseCase mockTogglePresence;
  late MockCallDoctorUseCase mockCallDoctor;
  late MockCompleteUseCase mockComplete;
  late MockCancelUseCase mockCancel;

  setUpAll(() {
    registerFallbackValue(const QueueFilter());
  });

  setUp(() {
    mockGetQueue = MockGetQueueUseCase();
    mockTogglePresence = MockTogglePresenceUseCase();
    mockCallDoctor = MockCallDoctorUseCase();
    mockComplete = MockCompleteUseCase();
    mockCancel = MockCancelUseCase();
  });

  const tItem = ReceptionQueueItemEntity(
    id: 1,
    ticketNumber: 'A001',
    patientId: 10,
    patientName: 'أحمد',
    doctorId: 2,
    doctorName: 'د. محمد',
    status: 'waiting',
    priority: 'normal',
    isPresent: true,
    waitMinutes: 10,
    capabilities: QueueCapabilitiesEntity(canTogglePresence: true, canCallDoctor: true),
  );

  const tQueue = ReceptionQueueEntity(
    items: [tItem],
    summary: QueueSummaryEntity(waiting: 1, total: 1),
    total: 1,
  );

  ReceptionQueueCubit buildCubit() => ReceptionQueueCubit(
        getQueueUseCase: mockGetQueue,
        togglePresenceUseCase: mockTogglePresence,
        callDoctorUseCase: mockCallDoctor,
        completeUseCase: mockComplete,
        cancelUseCase: mockCancel,
      );

  test('initial state is correct', () {
    final cubit = buildCubit();
    expect(cubit.state.status, ReceptionQueueStatus.initial);
    expect(cubit.state.queue.items, isEmpty);
  });

  blocTest<ReceptionQueueCubit, ReceptionQueueState>(
    'loadQueue emits loading then success on Right',
    build: () {
      when(() => mockGetQueue(any())).thenAnswer((_) async => const Right(tQueue));
      return buildCubit();
    },
    act: (cubit) => cubit.loadQueue(),
    expect: () => [
      const ReceptionQueueState(status: ReceptionQueueStatus.loading),
      isA<ReceptionQueueState>()
          .having((s) => s.status, 'status', ReceptionQueueStatus.success)
          .having((s) => s.queue, 'queue', tQueue),
    ],
  );

  blocTest<ReceptionQueueCubit, ReceptionQueueState>(
    'loadQueue emits loading then error on Left',
    build: () {
      when(() => mockGetQueue(any()))
          .thenAnswer((_) async => const Left(ServerFailure(message: 'Server error')));
      return buildCubit();
    },
    act: (cubit) => cubit.loadQueue(),
    expect: () => [
      const ReceptionQueueState(status: ReceptionQueueStatus.loading),
      isA<ReceptionQueueState>()
          .having((s) => s.status, 'status', ReceptionQueueStatus.error)
          .having((s) => s.errorMessage, 'errorMessage', 'Server error'),
    ],
  );

  blocTest<ReceptionQueueCubit, ReceptionQueueState>(
    'togglePresence updates item and sets actionFeedbackKey',
    build: () {
      final updatedItem = tItem.copyWith(isPresent: false);
      when(() => mockTogglePresence(
            id: 1,
            isPresent: false,
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => Right(updatedItem));
      return buildCubit();
    },
    seed: () => const ReceptionQueueState(
      status: ReceptionQueueStatus.success,
      queue: tQueue,
    ),
    act: (cubit) => cubit.togglePresence(1, false),
    expect: () => [
      isA<ReceptionQueueState>().having((s) => s.pendingActions[1], 'pending', 'presence'),
      isA<ReceptionQueueState>().having((s) => s.pendingActions.containsKey(1), 'cleared', false),
      isA<ReceptionQueueState>()
          .having((s) => s.actionFeedbackKey, 'feedback', 'reception_queue.absence_confirmed'),
    ],
  );

  blocTest<ReceptionQueueCubit, ReceptionQueueState>(
    'callDoctor transitions status and sets feedback',
    build: () {
      final updatedItem = tItem.copyWith(status: 'with_doctor');
      when(() => mockCallDoctor(
            id: 1,
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => Right(updatedItem));
      return buildCubit();
    },
    seed: () => const ReceptionQueueState(
      status: ReceptionQueueStatus.success,
      queue: tQueue,
    ),
    act: (cubit) => cubit.callDoctor(1),
    expect: () => [
      isA<ReceptionQueueState>().having((s) => s.pendingActions[1], 'pending', 'call_doctor'),
      isA<ReceptionQueueState>().having((s) => s.pendingActions.containsKey(1), 'cleared', false),
      isA<ReceptionQueueState>()
          .having((s) => s.actionFeedbackKey, 'feedback', 'reception_queue.patient_called_to_doctor'),
    ],
  );
}
