import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/examination_entity.dart';
import '../../domain/entities/visit_image_entity.dart';
import '../../domain/repositories/examination_repository.dart';
import '../data_sources/examination_remote_data_source.dart';

class ExaminationRepositoryImpl implements ExaminationRepository {
  final ExaminationRemoteDataSource _remoteDataSource;

  const ExaminationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, int>> startExamination(int waitingListId) async {
    try {
      final visitId = await _remoteDataSource.startExamination(waitingListId);
      return Right(visitId);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ExaminationEntity>> getExamination(int visitId) async {
    try {
      final model = await _remoteDataSource.getExamination(visitId);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> saveSection({
    required int visitId,
    required String section,
    required Map<String, dynamic> data,
  }) async {
    try {
      final result = await _remoteDataSource.saveSection(
        visitId: visitId,
        section: section,
        data: data,
      );
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<VisitImageEntity>>> uploadFiles({
    required int visitId,
    required List<String> filePaths,
    required String type,
    String? description,
  }) async {
    try {
      final images = await _remoteDataSource.uploadFiles(
        visitId: visitId,
        filePaths: filePaths,
        type: type,
        description: description,
      );
      return Right(images);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFile({
    required int visitId,
    required int imageId,
  }) async {
    try {
      await _remoteDataSource.deleteFile(
        visitId: visitId,
        imageId: imageId,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> completeExamination({
    required int visitId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _remoteDataSource.completeExamination(
        visitId: visitId,
        data: data,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> copyPreviousVisit({
    required int visitId,
    required int prevId,
  }) async {
    try {
      final result = await _remoteDataSource.copyPreviousVisit(
        visitId: visitId,
        prevId: prevId,
      );
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is DioException && exception.error != null) {
      return _mapExceptionToFailure(exception.error);
    }
    if (exception is UnauthorizedException) {
      return const UnauthorizedFailure();
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is NotFoundException) {
      return const NotFoundFailure();
    }
    if (exception is ServerException) {
      if (exception.fieldErrors != null && exception.fieldErrors!.isNotEmpty) {
        return ValidationFailure(
          message: exception.message,
          fieldErrors: exception.fieldErrors,
        );
      }
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    return const UnexpectedFailure();
  }
}
