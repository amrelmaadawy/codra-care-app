import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_queue_item_entity.dart';
import '../repositories/reception_queue_repository.dart';

class TogglePresenceUseCase {
  final ReceptionQueueRepository repository;

  const TogglePresenceUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueItemEntity>> call({
    required int id,
    required bool isPresent,
    String? clientRequestId,
  }) {
    return repository.togglePresence(
      id: id,
      isPresent: isPresent,
      clientRequestId: clientRequestId,
    );
  }
}
