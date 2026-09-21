import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/examination_repository.dart';

class CompleteExaminationUseCase {
  final ExaminationRepository _repository;

  const CompleteExaminationUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int visitId,
    required Map<String, dynamic> data,
  }) {
    return _repository.completeExamination(
      visitId: visitId,
      data: data,
    );
  }
}
