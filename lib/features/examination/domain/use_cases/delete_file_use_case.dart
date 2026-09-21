import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/examination_repository.dart';

class DeleteFileUseCase {
  final ExaminationRepository _repository;

  const DeleteFileUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int visitId,
    required int imageId,
  }) {
    return _repository.deleteFile(
      visitId: visitId,
      imageId: imageId,
    );
  }
}
