import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_leave_days_summary_entity.dart';
import '../../domain/repositories/doctor_leave_day_repository.dart';
import '../data_sources/doctor_leave_day_remote_data_source.dart';

class DoctorLeaveDayRepositoryImpl implements DoctorLeaveDayRepository {
  final DoctorLeaveDayRemoteDataSource _remoteDataSource;

  const DoctorLeaveDayRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> getSummaryData() async {
    try {
      final summary = await _remoteDataSource.getSummaryData();
      return Right(summary);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, int>> checkAppointmentsCount({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final count = await _remoteDataSource.checkAppointmentsCount(
        date: date,
        startDate: startDate,
        endDate: endDate,
      );
      return Right(count);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> addLeave({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  }) async {
    try {
      final summary = await _remoteDataSource.addLeave(
        leaveDate: leaveDate,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      return Right(summary);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> deleteLeave(int id) async {
    try {
      final summary = await _remoteDataSource.deleteLeave(id);
      return Right(summary);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> deleteLeaveByDate(
    String date,
  ) async {
    try {
      final summary = await _remoteDataSource.deleteLeaveByDate(date);
      return Right(summary);
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
