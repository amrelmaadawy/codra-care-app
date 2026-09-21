import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit_image_entity.dart';
import '../repositories/examination_repository.dart';

class UploadFilesUseCase {
  final ExaminationRepository _repository;

  const UploadFilesUseCase(this._repository);

  Future<Either<Failure, List<VisitImageEntity>>> call({
    required int visitId,
    required List<String> filePaths,
    required String type,
    String? description,
  }) {
    return _repository.uploadFiles(
      visitId: visitId,
      filePaths: filePaths,
      type: type,
      description: description,
    );
  }
}
