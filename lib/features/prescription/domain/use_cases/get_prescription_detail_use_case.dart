import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prescription_entity.dart';
import '../repositories/prescription_repository.dart';

class GetPrescriptionDetailUseCase {
  final PrescriptionRepository repository;

  const GetPrescriptionDetailUseCase(this.repository);

  Future<Either<Failure, PrescriptionEntity>> call(int id) {
    return repository.getPrescriptionDetail(id);
  }
}
