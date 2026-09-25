import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_queue_repository.dart';

class StartQueueExaminationUseCase {
  final DoctorQueueRepository _repository;

  const StartQueueExaminationUseCase(this._repository);

  Future<Either<Failure, int>> call(int waitingListId) {
    return _repository.startExamination(waitingListId);
  }
}
