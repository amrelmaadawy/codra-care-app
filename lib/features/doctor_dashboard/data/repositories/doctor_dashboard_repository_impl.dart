import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';
import '../../domain/repositories/doctor_dashboard_repository.dart';
import '../data_sources/doctor_dashboard_remote_data_source.dart';

class DoctorDashboardRepositoryImpl implements DoctorDashboardRepository {
  final DoctorDashboardRemoteDataSource _remoteDataSource;

  const DoctorDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorDashboardEntity>> getDashboardStats() async {
    try {
      final model = await _remoteDataSource.getDashboardStats();
      return Right(model);
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
