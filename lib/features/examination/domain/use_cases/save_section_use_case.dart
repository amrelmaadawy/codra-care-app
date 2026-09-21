import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/examination_repository.dart';

class SaveSectionUseCase {
  final ExaminationRepository _repository;

  const SaveSectionUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call({
    required int visitId,
    required String section,
    required Map<String, dynamic> data,
  }) {
    return _repository.saveSection(
      visitId: visitId,
      section: section,
      data: data,
    );
  }
}
