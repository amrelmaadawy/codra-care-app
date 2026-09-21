import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_dashboard_entity.dart';
import '../repositories/doctor_dashboard_repository.dart';

class GetDoctorDashboardUseCase {
  final DoctorDashboardRepository _repository;

  const GetDoctorDashboardUseCase(this._repository);

  Future<Either<Failure, DoctorDashboardEntity>> call() {
    return _repository.getDashboardStats();
  }
}
