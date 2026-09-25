import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_appointment_result_entity.dart';
import '../entities/create_appointment_params.dart';
import '../repositories/reception_booking_repository.dart';

class CreateAppointmentUseCase {
  final ReceptionBookingRepository _repository;

  const CreateAppointmentUseCase({
    required this._repository,
  });

  Future<Either<Failure, BookingAppointmentResultEntity>> call(
    CreateAppointmentParams params,
  ) {
    return _repository.createAppointment(params);
  }
}
