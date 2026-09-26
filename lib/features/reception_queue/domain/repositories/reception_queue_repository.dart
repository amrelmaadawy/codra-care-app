import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/queue_filter.dart';
import '../entities/reception_queue_entity.dart';
import '../entities/reception_queue_item_entity.dart';

abstract class ReceptionQueueRepository {
  Future<Either<Failure, ReceptionQueueEntity>> getQueue(QueueFilter filter);

  Future<Either<Failure, ReceptionQueueItemEntity>> togglePresence({
    required int id,
    required bool isPresent,
    String? clientRequestId,
  });

  Future<Either<Failure, ReceptionQueueItemEntity>> saveVitals({
    required int id,
    required Map<String, dynamic> vitals,
    String? clientRequestId,
  });

  Future<Either<Failure, ReceptionQueueItemEntity>> callDoctor({
    required int id,
    String? clientRequestId,
  });

  Future<Either<Failure, ReceptionQueueItemEntity>> complete({
    required int id,
    String? clientRequestId,
  });

  Future<Either<Failure, ReceptionQueueItemEntity>> cancel({
    required int id,
    required String reason,
    String? clientRequestId,
  });
}
