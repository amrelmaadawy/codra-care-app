import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescription_repository.dart';

class UpdatePrescriptionUseCase {
  final PrescriptionRepository repository;

  const UpdatePrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call({
    required int id,
    int? patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) {
    return repository.updatePrescription(
      id: id,
      patientId: patientId,
      visitId: visitId,
      notes: notes,
      items: items,
    );
  }
}
