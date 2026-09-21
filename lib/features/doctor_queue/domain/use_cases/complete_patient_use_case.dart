import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_queue_repository.dart';

class CompletePatientUseCase {
  final DoctorQueueRepository _repository;

  const CompletePatientUseCase(this._repository);

  Future<Either<Failure, void>> call(int id) {
    return _repository.completePatient(id);
  }
}
