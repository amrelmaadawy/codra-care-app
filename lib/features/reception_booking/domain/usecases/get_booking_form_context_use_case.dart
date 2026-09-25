import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_form_context_entity.dart';
import '../repositories/reception_booking_repository.dart';

class GetBookingFormContextUseCase {
  final ReceptionBookingRepository _repository;

  const GetBookingFormContextUseCase({
    required this._repository,
  });

  Future<Either<Failure, BookingFormContextEntity>> call({
    int? doctorId,
    String? date,
  }) {
    return _repository.getFormContext(doctorId: doctorId, date: date);
  }
}
