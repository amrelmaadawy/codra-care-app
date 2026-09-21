import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_entity.dart';
import 'package:medical_erp/features/prescription/domain/entities/prescription_patient_entity.dart';
import 'package:medical_erp/features/prescription/domain/repositories/prescription_repository.dart';
import 'package:medical_erp/features/prescription/domain/use_cases/create_prescription_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockPrescriptionRepository extends Mock implements PrescriptionRepository {}

void main() {
  late CreatePrescriptionUseCase useCase;
  late MockPrescriptionRepository mockRepository;

  setUp(() {
    mockRepository = MockPrescriptionRepository();
    useCase = CreatePrescriptionUseCase(mockRepository);
  });

  const tRx = PrescriptionEntity(
    id: 1,
    prescriptionNumber: 'RX-1',
    patient: PrescriptionPatientEntity(id: 2, fullName: 'فاطمة'),
  );

  final tItems = [
    {
      'drug_name': 'Amoxicillin',
      'dosage': '500mg',
      'frequency': 'TDS',
      'duration': '7 days',
      'route': 'oral',
    }
  ];

  test('should return PrescriptionEntity when repository succeeds', () async {
    when(() => mockRepository.createPrescription(
          patientId: 2,
          visitId: 3,
          notes: 'notes',
          items: tItems,
        )).thenAnswer((_) async => const Right(tRx));

    final result = await useCase(
      patientId: 2,
      visitId: 3,
      notes: 'notes',
      items: tItems,
    );

    expect(result, const Right(tRx));
    verify(() => mockRepository.createPrescription(
          patientId: 2,
          visitId: 3,
          notes: 'notes',
          items: tItems,
        )).called(1);
  });

  test('should return Failure when repository fails', () async {
    when(() => mockRepository.createPrescription(
          patientId: 2,
          items: tItems,
        )).thenAnswer((_) async => const Left(ServerFailure(message: 'Failed')));

    final result = await useCase(patientId: 2, items: tItems);

    expect(result, const Left(ServerFailure(message: 'Failed')));
  });
}
