import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescription_repository.dart';

class CreatePrescriptionUseCase {
  final PrescriptionRepository repository;

  const CreatePrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required int patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) {
    return repository.createPrescription(
      patientId: patientId,
      visitId: visitId,
      notes: notes,
      items: items,
    );
  }
}
