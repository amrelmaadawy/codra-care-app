import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnosis_template_entity.dart';
import '../../domain/entities/paginated_diagnosis_templates_entity.dart';
import '../../domain/repositories/diagnosis_template_repository.dart';
import '../data_sources/diagnosis_template_remote_data_source.dart';

class DiagnosisTemplateRepositoryImpl implements DiagnosisTemplateRepository {
  final DiagnosisTemplateRemoteDataSource _remoteDataSource;

  const DiagnosisTemplateRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaginatedDiagnosisTemplatesEntity>> getDiagnosisTemplates({
    int page = 1,
    String? search,
  }) async {
    try {
      final model = await _remoteDataSource.getDiagnosisTemplates(
        page: page,
        search: search,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<DiagnosisTemplateEntity>>> getDiagnosisTemplatesForExam({
    String? search,
    int limit = 50,
  }) async {
    try {
      final list = await _remoteDataSource.getDiagnosisTemplatesForExam(
        search: search,
        limit: limit,
      );
      return Right(list);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiagnosisTemplateEntity>> getDiagnosisTemplateDetail(
    int id,
  ) async {
    try {
      final model = await _remoteDataSource.getDiagnosisTemplateDetail(id);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiagnosisTemplateEntity>> createDiagnosisTemplate({
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    try {
      final model = await _remoteDataSource.createDiagnosisTemplate(
        title: title,
        chiefComplaint: chiefComplaint,
        diagnosis: diagnosis,
        notes: notes,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DiagnosisTemplateEntity>> updateDiagnosisTemplate({
    required int id,
    required String title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
  }) async {
    try {
      final model = await _remoteDataSource.updateDiagnosisTemplate(
        id: id,
        title: title,
        chiefComplaint: chiefComplaint,
        diagnosis: diagnosis,
        notes: notes,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiagnosisTemplate(int id) async {
    try {
      await _remoteDataSource.deleteDiagnosisTemplate(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> useDiagnosisTemplate(int id) async {
    try {
      await _remoteDataSource.useDiagnosisTemplate(id);
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
      if (exception.fieldErrors != null &&
          exception.fieldErrors!.isNotEmpty) {
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
