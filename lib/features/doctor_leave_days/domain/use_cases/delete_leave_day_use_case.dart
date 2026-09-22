import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_leave_days_summary_entity.dart';
import '../repositories/doctor_leave_day_repository.dart';

class DeleteLeaveDayUseCase {
  final DoctorLeaveDayRepository _repository;

  const DeleteLeaveDayUseCase(this._repository);

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> callById(int id) {
    return _repository.deleteLeave(id);
  }

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> callByDate(String date) {
    return _repository.deleteLeaveByDate(date);
  }
}
