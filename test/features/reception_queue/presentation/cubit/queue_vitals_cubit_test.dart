import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/queue_capabilities_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/entities/reception_queue_item_entity.dart';
import 'package:medical_erp/features/reception_queue/domain/use_cases/save_queue_vitals_use_case.dart';
import 'package:medical_erp/features/reception_queue/presentation/cubit/queue_vitals_cubit.dart';
import 'package:medical_erp/features/reception_queue/presentation/cubit/queue_vitals_state.dart';
import 'package:mocktail/mocktail.dart';

class MockSaveVitalsUseCase extends Mock implements SaveQueueVitalsUseCase {}

void main() {
  late MockSaveVitalsUseCase mockSaveVitals;

  setUp(() {
    mockSaveVitals = MockSaveVitalsUseCase();
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
    capabilities: QueueCapabilitiesEntity(canSaveVitals: true),
  );

  test('validates that at least one vital sign is required', () async {
    final cubit = QueueVitalsCubit(queueId: 1, saveQueueVitalsUseCase: mockSaveVitals);
    await cubit.submit();

    expect(cubit.state.errorMessage, 'reception_queue.vitals_required_validation');
    verifyZeroInteractions(mockSaveVitals);
  });

  test('validates diastolic must be less than systolic', () async {
    final cubit = QueueVitalsCubit(queueId: 1, saveQueueVitalsUseCase: mockSaveVitals);
    cubit.setBpSystolic(100);
    cubit.setBpDiastolic(120);
    await cubit.submit();

    expect(cubit.state.errorMessage, 'reception_queue.bp_diastolic_greater_than_systolic');
    verifyZeroInteractions(mockSaveVitals);
  });

  test('computes BMI correctly from weight and height', () {
    final cubit = QueueVitalsCubit(queueId: 1, saveQueueVitalsUseCase: mockSaveVitals);
    cubit.setWeightKg(75.0);
    cubit.setHeightCm(175.0);

    expect(cubit.state.computedBmi, 24.5);
  });

  blocTest<QueueVitalsCubit, QueueVitalsState>(
    'submits vitals and emits success',
    build: () {
      when(() => mockSaveVitals(
            id: 1,
            vitals: any(named: 'vitals'),
            clientRequestId: any(named: 'clientRequestId'),
          )).thenAnswer((_) async => const Right(tItem));
      return QueueVitalsCubit(queueId: 1, saveQueueVitalsUseCase: mockSaveVitals);
    },
    act: (cubit) {
      cubit.setTemperature(37.0);
      cubit.submit();
    },
    expect: () => [
      isA<QueueVitalsState>().having((s) => s.temperature, 'temp', 37.0),
      isA<QueueVitalsState>().having((s) => s.status, 'status', QueueVitalsStatus.submitting),
      isA<QueueVitalsState>()
          .having((s) => s.status, 'status', QueueVitalsStatus.success)
          .having((s) => s.savedItem, 'item', tItem),
    ],
  );
}
