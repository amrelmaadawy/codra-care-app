import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_leave_days_summary_entity.dart';
import '../repositories/doctor_leave_day_repository.dart';

class AddLeaveDayUseCase {
  final DoctorLeaveDayRepository _repository;

  const AddLeaveDayUseCase(this._repository);

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> call({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  }) {
    return _repository.addLeave(
      leaveDate: leaveDate,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }
}
