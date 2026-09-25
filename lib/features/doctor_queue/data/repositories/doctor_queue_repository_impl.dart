import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
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

  @override
  Future<Either<Failure, int>> startExamination(int waitingListId) async {
    try {
      final visitId = await _remoteDataSource.startExamination(waitingListId);
      return Right(visitId);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) =>
      FailureMapper.mapExceptionToFailure(exception);
}
