import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_context_entity.dart';
import '../repositories/prescription_repository.dart';

class GetPrescriptionContextUseCase {
  final PrescriptionRepository repository;

  const GetPrescriptionContextUseCase(this.repository);

  Future<Either<Failure, PrescriptionContextEntity>> call({
    int? visitId,
    int? patientId,
  }) {
    return repository.getCreateContext(
      visitId: visitId,
      patientId: patientId,
    );
  }
}
