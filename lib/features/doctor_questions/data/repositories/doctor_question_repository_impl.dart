import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_question_entity.dart';
import '../../domain/repositories/doctor_question_repository.dart';
import '../data_sources/doctor_question_remote_data_source.dart';

class DoctorQuestionRepositoryImpl implements DoctorQuestionRepository {
  final DoctorQuestionRemoteDataSource _remoteDataSource;

  const DoctorQuestionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<DoctorQuestionEntity>>> getQuestions() async {
    try {
      final list = await _remoteDataSource.getQuestions();
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorQuestionEntity>> createQuestion({
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
    bool isActive = true,
  }) async {
    try {
      final model = await _remoteDataSource.createQuestion(
        text: text,
        type: type,
        options: options,
        isRequired: isRequired,
        isActive: isActive,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorQuestionEntity>> updateQuestion({
    required int id,
    required String text,
    required DoctorQuestionType type,
    List<String>? options,
    required bool isRequired,
  }) async {
    try {
      final model = await _remoteDataSource.updateQuestion(
        id: id,
        text: text,
        type: type,
        options: options,
        isRequired: isRequired,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteQuestion(int id) async {
    try {
      await _remoteDataSource.deleteQuestion(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorQuestionEntity>> toggleQuestion(int id) async {
    try {
      final model = await _remoteDataSource.toggleQuestion(id);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> reorderQuestions(List<int> orderedIds) async {
    try {
      await _remoteDataSource.reorderQuestions(orderedIds);
      return const Right(null);
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
