import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/booking_patient_entity.dart';
import '../repositories/reception_booking_repository.dart';

class SearchPatientsUseCase {
  final ReceptionBookingRepository _repository;

  const SearchPatientsUseCase({required this._repository});

  Future<Either<Failure, List<BookingPatientEntity>>> call(String query) {
    return _repository.searchPatients(query);
  }
}
