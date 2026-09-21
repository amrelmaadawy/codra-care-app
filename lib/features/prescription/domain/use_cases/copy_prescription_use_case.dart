import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescription_repository.dart';

class CopyPrescriptionUseCase {
  final PrescriptionRepository repository;

  const CopyPrescriptionUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call(int id) {
    return repository.copyPrescription(id);
  }
}
