import 'package:dartz/dartz.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/follow_ups_page_entity.dart';
import '../../domain/entities/get_follow_ups_params.dart';
import '../../domain/repositories/reception_follow_ups_repository.dart';
import '../datasources/reception_follow_ups_remote_data_source.dart';

class ReceptionFollowUpsRepositoryImpl
    implements ReceptionFollowUpsRepository {
  final ReceptionFollowUpsRemoteDataSource _remoteDataSource;

  const ReceptionFollowUpsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, FollowUpsPageEntity>> getFollowUps(
    GetFollowUpsParams params,
  ) async {
    try {
      final model = await _remoteDataSource.getFollowUps(params);
      return Right(model);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
