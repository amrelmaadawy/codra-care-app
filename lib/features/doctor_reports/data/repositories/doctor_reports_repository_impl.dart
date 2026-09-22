import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_reports_response_entity.dart';
import '../../domain/repositories/doctor_reports_repository.dart';
import '../data_sources/doctor_reports_remote_data_source.dart';

class DoctorReportsRepositoryImpl implements DoctorReportsRepository {
  final DoctorReportsRemoteDataSource _remoteDataSource;

  const DoctorReportsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorReportsResponseEntity>> getReports({
    int? month,
    int? year,
    int page = 1,
    int perPage = 15,
    String? search,
  }) async {
    try {
      final result = await _remoteDataSource.getReports(
        month: month,
        year: year,
        page: page,
        perPage: perPage,
        search: search,
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
