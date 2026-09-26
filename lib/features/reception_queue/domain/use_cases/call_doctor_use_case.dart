import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_queue_item_entity.dart';
import '../repositories/reception_queue_repository.dart';

class CallDoctorUseCase {
  final ReceptionQueueRepository repository;

  const CallDoctorUseCase(this.repository);

  Future<Either<Failure, ReceptionQueueItemEntity>> call({
    required int id,
    String? clientRequestId,
  }) {
    return repository.callDoctor(
      id: id,
      clientRequestId: clientRequestId,
    );
  }
}
