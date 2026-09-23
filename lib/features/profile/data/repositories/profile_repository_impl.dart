import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorProfileEntity>> getProfile() async {
    try {
      final model = await _remoteDataSource.getProfile();
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorProfileEntity>> updateProfile({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) async {
    try {
      final model = await _remoteDataSource.updateProfile(
        name: name,
        specialization: specialization,
        phone: phone,
        licenseNumber: licenseNumber,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await _remoteDataSource.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, DoctorProfileEntity>> updatePhoto(
      String filePath) async {
    try {
      final model = await _remoteDataSource.updatePhoto(filePath);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object? exception) {
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
