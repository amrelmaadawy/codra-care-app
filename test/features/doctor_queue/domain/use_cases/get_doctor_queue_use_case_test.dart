import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/doctor_queue_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/queue_patient_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/entities/queue_summary_entity.dart';
import 'package:medical_erp/features/doctor_queue/domain/repositories/doctor_queue_repository.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/call_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/cancel_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/complete_patient_use_case.dart';
import 'package:medical_erp/features/doctor_queue/domain/use_cases/get_doctor_queue_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockDoctorQueueRepository extends Mock implements DoctorQueueRepository {}

void main() {
  late MockDoctorQueueRepository mockRepository;
  late GetDoctorQueueUseCase getQueueUseCase;
  late CallPatientUseCase callPatientUseCase;
  late CompletePatientUseCase completePatientUseCase;
  late CancelPatientUseCase cancelPatientUseCase;

  setUp(() {
    mockRepository = MockDoctorQueueRepository();
    getQueueUseCase = GetDoctorQueueUseCase(mockRepository);
    callPatientUseCase = CallPatientUseCase(mockRepository);
    completePatientUseCase = CompletePatientUseCase(mockRepository);
    cancelPatientUseCase = CancelPatientUseCase(mockRepository);
  });

  const tPatient = QueuePatientEntity(
    id: 1,
    ticketNumber: 'A-01',
    patientName: 'أحمد علي',
    patientPhone: '01012345678',
    patientAge: 35,
    patientGender: 'ذكر',
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

  const tQueueEntity = DoctorQueueEntity(
    items: [tPatient],
    summary: tSummary,
  );

  group('GetDoctorQueueUseCase', () {
    test('should return DoctorQueueEntity when repository call is successful', () async {
      when(() => mockRepository.getQueue())
          .thenAnswer((_) async => const Right(tQueueEntity));

      final result = await getQueueUseCase();

      expect(result, const Right(tQueueEntity));
      verify(() => mockRepository.getQueue()).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      const tFailure = ServerFailure(message: 'Server error');
      when(() => mockRepository.getQueue())
          .thenAnswer((_) async => const Left(tFailure));

      final result = await getQueueUseCase();

      expect(result, const Left(tFailure));
      verify(() => mockRepository.getQueue()).called(1);
    });
  });

  group('Action Use Cases', () {
    test('CallPatientUseCase calls repository.callPatient', () async {
      when(() => mockRepository.callPatient(1))
          .thenAnswer((_) async => const Right(null));

      final result = await callPatientUseCase(1);

      expect(result, const Right(null));
      verify(() => mockRepository.callPatient(1)).called(1);
    });

    test('CompletePatientUseCase calls repository.completePatient', () async {
      when(() => mockRepository.completePatient(1))
          .thenAnswer((_) async => const Right(null));

      final result = await completePatientUseCase(1);

      expect(result, const Right(null));
      verify(() => mockRepository.completePatient(1)).called(1);
    });

    test('CancelPatientUseCase calls repository.cancelPatient', () async {
      when(() => mockRepository.cancelPatient(1))
          .thenAnswer((_) async => const Right(null));

      final result = await cancelPatientUseCase(1);

      expect(result, const Right(null));
      verify(() => mockRepository.cancelPatient(1)).called(1);
    });
  });
}
