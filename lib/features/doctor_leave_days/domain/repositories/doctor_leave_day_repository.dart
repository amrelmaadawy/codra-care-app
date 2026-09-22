import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_leave_days_summary_entity.dart';

abstract class DoctorLeaveDayRepository {
  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> getSummaryData();

  Future<Either<Failure, int>> checkAppointmentsCount({
    String? date,
    String? startDate,
    String? endDate,
  });

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> addLeave({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  });

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> deleteLeave(int id);

  Future<Either<Failure, DoctorLeaveDaysSummaryEntity>> deleteLeaveByDate(String date);
}
