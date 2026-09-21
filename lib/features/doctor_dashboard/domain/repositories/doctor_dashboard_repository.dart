import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_dashboard_entity.dart';

abstract class DoctorDashboardRepository {
  Future<Either<Failure, DoctorDashboardEntity>> getDashboardStats();
}
