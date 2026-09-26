import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/queue_filter.dart';
import '../../domain/entities/reception_queue_entity.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import '../../domain/repositories/reception_queue_repository.dart';
import '../data_sources/reception_queue_remote_data_source.dart';

class ReceptionQueueRepositoryImpl implements ReceptionQueueRepository {
  final ReceptionQueueRemoteDataSource _remoteDataSource;

  const ReceptionQueueRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReceptionQueueEntity>> getQueue(QueueFilter filter) async {
    try {
      final model = await _remoteDataSource.getQueue(filter);
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ReceptionQueueItemEntity>> togglePresence({
    required int id,
    required bool isPresent,
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.togglePresence(
        id: id,
        isPresent: isPresent,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ReceptionQueueItemEntity>> saveVitals({
    required int id,
    required Map<String, dynamic> vitals,
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.saveVitals(
        id: id,
        vitals: vitals,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ReceptionQueueItemEntity>> callDoctor({
    required int id,
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.callDoctor(
        id: id,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ReceptionQueueItemEntity>> complete({
    required int id,
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.complete(
        id: id,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ReceptionQueueItemEntity>> cancel({
    required int id,
    required String reason,
    String? clientRequestId,
  }) async {
    try {
      final model = await _remoteDataSource.cancel(
        id: id,
        reason: reason,
        clientRequestId: clientRequestId,
      );
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
