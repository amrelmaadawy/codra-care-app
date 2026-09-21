import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/examination_repository.dart';

class StartExaminationUseCase {
  final ExaminationRepository _repository;

  const StartExaminationUseCase(this._repository);

  Future<Either<Failure, int>> call(int waitingListId) {
    return _repository.startExamination(waitingListId);
  }
}
