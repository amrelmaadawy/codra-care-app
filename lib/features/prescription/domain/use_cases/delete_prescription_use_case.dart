import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/prescription_repository.dart';

class DeletePrescriptionUseCase {
  final PrescriptionRepository repository;

  const DeletePrescriptionUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePrescription(id);
  }
}
