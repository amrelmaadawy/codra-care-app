import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/examination_entity.dart';
import '../entities/visit_image_entity.dart';

abstract class ExaminationRepository {
  Future<Either<Failure, int>> startExamination(int waitingListId);

  Future<Either<Failure, ExaminationEntity>> getExamination(int visitId);

  Future<Either<Failure, Map<String, dynamic>>> saveSection({
    required int visitId,
    required String section,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, List<VisitImageEntity>>> uploadFiles({
    required int visitId,
    required List<String> filePaths,
    required String type,
    String? description,
  });

  Future<Either<Failure, void>> deleteFile({
    required int visitId,
    required int imageId,
  });

  Future<Either<Failure, void>> completeExamination({
    required int visitId,
    required Map<String, dynamic> data,
  });

  Future<Either<Failure, Map<String, dynamic>>> copyPreviousVisit({
    required int visitId,
    required int prevId,
  });
}
