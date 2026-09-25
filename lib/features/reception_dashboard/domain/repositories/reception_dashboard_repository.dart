import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_dashboard_entity.dart';

abstract class ReceptionDashboardRepository {
  Future<Either<Failure, ReceptionDashboardEntity>> getDashboard({
    int? doctorId,
  });
}
