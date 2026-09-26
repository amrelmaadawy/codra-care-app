import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_queue_item_entity.dart';
import '../repositories/reception_queue_repository.dart';

class CompleteQueueItemUseCase {
  final ReceptionQueueRepository repository;

  const CompleteQueueItemUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueItemEntity>> call({
    required int id,
    String? clientRequestId,
  }) {
    return repository.complete(
      id: id,
      clientRequestId: clientRequestId,
    );
  }
}
