import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/follow_up_schedule_context_entity.dart';
import '../repositories/reception_booking_repository.dart';

class GetFollowUpScheduleContextUseCase {
  final ReceptionBookingRepository repository;

  const GetFollowUpScheduleContextUseCase(this.repository);

  Future<Either<Failure, FollowUpScheduleContextEntity>> call(int visitId) {
    return repository.getFollowUpScheduleContext(visitId);
  }
}
