import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_notification_entity.dart';
import '../../domain/repositories/doctor_notifications_repository.dart';
import '../data_sources/doctor_notifications_remote_data_source.dart';

class DoctorNotificationsRepositoryImpl implements DoctorNotificationsRepository {
  final DoctorNotificationsRemoteDataSource _remoteDataSource;

  const DoctorNotificationsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorNotificationsEntity>> getNotifications() async {
    try {
      final result = await _remoteDataSource.getNotifications();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead({
    required NotificationType type,
    required dynamic id,
  }) async {
    try {
      final result = await _remoteDataSource.markAsRead(type: type, id: id);
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> markAll() async {
    try {
      final result = await _remoteDataSource.markAll();
      return Right(result);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is DioException && exception.error != null) {
      return _mapExceptionToFailure(exception.error);
    }
    if (exception is UnauthorizedException) return const UnauthorizedFailure();
    if (exception is NetworkException) return const NetworkFailure();
    if (exception is NotFoundException) return const NotFoundFailure();
    if (exception is ServerException) {
      if (exception.fieldErrors != null && exception.fieldErrors!.isNotEmpty) {
        return ValidationFailure(
          message: exception.message,
          fieldErrors: exception.fieldErrors,
        );
      }
      return ServerFailure(message: exception.message, statusCode: exception.statusCode);
    }
    return const UnexpectedFailure();
  }
}
