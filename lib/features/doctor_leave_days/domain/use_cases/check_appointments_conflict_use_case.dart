import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/doctor_leave_day_repository.dart';

class CheckAppointmentsConflictUseCase {
  final DoctorLeaveDayRepository _repository;

  const CheckAppointmentsConflictUseCase(this._repository);

  Future<Either<Failure, int>> call({
    String? date,
    String? startDate,
    String? endDate,
  }) {
    return _repository.checkAppointmentsCount(
      date: date,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
