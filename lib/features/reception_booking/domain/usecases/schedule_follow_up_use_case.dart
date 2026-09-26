import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_appointment_result_entity.dart';
import '../entities/schedule_follow_up_params.dart';
import '../repositories/reception_booking_repository.dart';

class ScheduleFollowUpUseCase {
  final ReceptionBookingRepository repository;

  const ScheduleFollowUpUseCase(this.repository);

  Future<Either<Failure, BookingAppointmentResultEntity>> call(
    ScheduleFollowUpParams params,
  ) {
    return repository.scheduleFollowUp(params);
  }
}
