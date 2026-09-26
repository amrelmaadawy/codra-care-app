import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/follow_ups_page_entity.dart';
import '../entities/get_follow_ups_params.dart';

abstract class ReceptionFollowUpsRepository {
  Future<Either<Failure, FollowUpsPageEntity>> getFollowUps(
    GetFollowUpsParams params,
  );
}
