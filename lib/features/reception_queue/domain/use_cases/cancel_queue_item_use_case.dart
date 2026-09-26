import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_queue_item_entity.dart';
import '../repositories/reception_queue_repository.dart';

class CancelQueueItemUseCase {
  final ReceptionQueueRepository repository;

  const CancelQueueItemUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueItemEntity>> call({
    required int id,
    required String reason,
    String? clientRequestId,
  }) {
    return repository.cancel(
      id: id,
      reason: reason,
      clientRequestId: clientRequestId,
    );
  }
}
