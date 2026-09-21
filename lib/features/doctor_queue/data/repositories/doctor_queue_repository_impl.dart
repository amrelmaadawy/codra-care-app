import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_queue_entity.dart';
import '../../domain/repositories/doctor_queue_repository.dart';
import '../data_sources/doctor_queue_remote_data_source.dart';

class DoctorQueueRepositoryImpl implements DoctorQueueRepository {
  final DoctorQueueRemoteDataSource _remoteDataSource;

  const DoctorQueueRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorQueueEntity>> getQueue() async {
    try {
      final model = await _remoteDataSource.getQueue();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> callPatient(int id) async {
    try {
      await _remoteDataSource.callPatient(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> completePatient(int id) async {
    try {
      await _remoteDataSource.completePatient(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> cancelPatient(int id) async {
    try {
      await _remoteDataSource.cancelPatient(id);
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
