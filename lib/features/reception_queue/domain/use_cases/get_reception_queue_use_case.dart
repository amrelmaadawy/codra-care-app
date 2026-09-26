import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/queue_filter.dart';
import '../entities/reception_queue_entity.dart';
import '../repositories/reception_queue_repository.dart';

class GetReceptionQueueUseCase {
  final ReceptionQueueRepository repository;

  const GetReceptionQueueUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueEntity>> call(QueueFilter filter) {
    return repository.getQueue(filter);
  }
}
