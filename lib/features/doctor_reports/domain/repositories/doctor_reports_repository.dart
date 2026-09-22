import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_reports_response_entity.dart';

abstract class DoctorReportsRepository {
  Future<Either<Failure, DoctorReportsResponseEntity>> getReports({
    int? month,
    int? year,
    int page = 1,
    int perPage = 15,
    String? search,
  });
}
