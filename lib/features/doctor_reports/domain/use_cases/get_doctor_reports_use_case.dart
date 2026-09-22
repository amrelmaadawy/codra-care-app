import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_reports_response_entity.dart';
import '../repositories/doctor_reports_repository.dart';

class GetDoctorReportsUseCase {
  final DoctorReportsRepository _repository;

  const GetDoctorReportsUseCase(this._repository);

  Future<Either<Failure, DoctorReportsResponseEntity>> call({
    int? month,
    int? year,
    int page = 1,
    int perPage = 15,
    String? search,
  }) {
    return _repository.getReports(
      month: month,
      year: year,
      page: page,
      perPage: perPage,
      search: search,
    );
  }
}
