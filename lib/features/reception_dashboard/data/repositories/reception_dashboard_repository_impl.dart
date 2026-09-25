import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reception_dashboard_entity.dart';
import '../../domain/repositories/reception_dashboard_repository.dart';
import '../data_sources/reception_dashboard_remote_data_source.dart';

class ReceptionDashboardRepositoryImpl implements ReceptionDashboardRepository {
  final ReceptionDashboardRemoteDataSource _remoteDataSource;

  const ReceptionDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ReceptionDashboardEntity>> getDashboard({
    int? doctorId,
  }) async {
    try {
      final model = await _remoteDataSource.getDashboard(doctorId: doctorId);
      return Right(model);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) =>
      FailureMapper.mapExceptionToFailure(exception);
}
