import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_queue_item_entity.dart';
import '../repositories/reception_queue_repository.dart';

class SaveQueueVitalsUseCase {
  final ReceptionQueueRepository repository;

  const SaveQueueVitalsUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueItemEntity>> call({
    required int id,
    required Map<String, dynamic> vitals,
    String? clientRequestId,
  }) {
    return repository.saveVitals(
      id: id,
      vitals: vitals,
      clientRequestId: clientRequestId,
    );
  }
}
