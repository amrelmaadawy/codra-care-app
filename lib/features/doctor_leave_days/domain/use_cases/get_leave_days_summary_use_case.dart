import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_leave_days_summary_entity.dart';
import '../repositories/doctor_leave_day_repository.dart';

class GetLeaveDaysSummaryUseCase {
  final DoctorLeaveDayRepository _repository;

  const GetLeaveDaysSummaryUseCase(this._repository);

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> call() {
    return _repository.getSummaryData();
  }
}
