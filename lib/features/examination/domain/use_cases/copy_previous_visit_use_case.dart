import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/examination_repository.dart';

class CopyPreviousVisitUseCase {
  final ExaminationRepository _repository;

  const CopyPreviousVisitUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required int visitId,
    required int prevId,
  }) {
    return _repository.copyPreviousVisit(
      visitId: visitId,
      prevId: prevId,
    );
  }
}
