import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/examination_entity.dart';
import '../repositories/examination_repository.dart';

class GetExaminationUseCase {
  final ExaminationRepository _repository;

  const GetExaminationUseCase(this._repository);

  Future<Either<Failure, ExaminationEntity>> call(int visitId) {
    return _repository.getExamination(visitId);
  }
}
