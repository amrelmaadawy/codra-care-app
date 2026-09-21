import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_queue_entity.dart';
import '../repositories/doctor_queue_repository.dart';

class GetDoctorQueueUseCase {
  final DoctorQueueRepository _repository;

  const GetDoctorQueueUseCase(this._repository);

  Future<Either<Failure, DoctorQueueEntity>> call() {
    return _repository.getQueue();
  }
}
