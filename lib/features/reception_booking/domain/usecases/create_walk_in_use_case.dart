import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/walk_in_params.dart';
import '../entities/walk_in_result_entity.dart';
import '../repositories/reception_booking_repository.dart';

class CreateWalkInUseCase {
  final ReceptionBookingRepository repository;

  const CreateWalkInUseCase(this.repository);

  Future<Either<Failure, WalkInResultEntity>> call(WalkInParams params) {
    return repository.createWalkIn(params);
  }
}
