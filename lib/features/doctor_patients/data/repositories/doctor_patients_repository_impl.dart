import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_detail_entity.dart';
import '../../domain/entities/patient_list_result_entity.dart';
import '../../domain/repositories/doctor_patients_repository.dart';
import '../data_sources/doctor_patients_remote_data_source.dart';

class DoctorPatientsRepositoryImpl implements DoctorPatientsRepository {
  final DoctorPatientsRemoteDataSource _remoteDataSource;

  const DoctorPatientsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PatientListResultEntity>> getPatients({
    String? search,
    int page = 1,
  }) async {
    try {
      final model = await _remoteDataSource.getPatients(
        search: search,
        page: page,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PatientDetailEntity>> getPatientDetail(int id) async {
    try {
      final model = await _remoteDataSource.getPatientDetail(id);
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
