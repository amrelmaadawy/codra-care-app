import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/paginated_prescriptions_entity.dart';
import '../../domain/entities/prescription_context_entity.dart';
import '../../domain/entities/prescription_entity.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../data_sources/prescription_remote_data_source.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionRemoteDataSource _remoteDataSource;

  const PrescriptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, PaginatedPrescriptionsEntity>> getPrescriptions({
    int page = 1,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? isPrinted,
  }) async {
    try {
      final model = await _remoteDataSource.getPrescriptions(
        page: page,
        search: search,
        dateFrom: dateFrom,
        dateTo: dateTo,
        isPrinted: isPrinted,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionContextEntity>> getCreateContext({
    int? visitId,
    int? patientId,
  }) async {
    try {
      final model = await _remoteDataSource.getCreateContext(
        visitId: visitId,
        patientId: patientId,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> getPrescriptionDetail(
    int id,
  ) async {
    try {
      final model = await _remoteDataSource.getPrescriptionDetail(id);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> createPrescription({
    required int patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final model = await _remoteDataSource.createPrescription(
        patientId: patientId,
        visitId: visitId,
        notes: notes,
        items: items,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required int id,
    int? patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final model = await _remoteDataSource.updatePrescription(
        id: id,
        patientId: patientId,
        visitId: visitId,
        notes: notes,
        items: items,
      );
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePrescription(int id) async {
    try {
      await _remoteDataSource.deletePrescription(id);
      return const Right(null);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, PrescriptionEntity>> copyPrescription(int id) async {
    try {
      final model = await _remoteDataSource.copyPrescription(id);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markPrinted(int id) async {
    try {
      await _remoteDataSource.markPrinted(id);
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
