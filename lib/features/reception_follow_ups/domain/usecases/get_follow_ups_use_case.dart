import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/follow_ups_page_entity.dart';
import '../entities/get_follow_ups_params.dart';
import '../repositories/reception_follow_ups_repository.dart';

class GetFollowUpsUseCase {
  final ReceptionFollowUpsRepository repository;

  const GetFollowUpsUseCase(this.repository);

  Future<Either<Failure, FollowUpsPageEntity>> call(
    GetFollowUpsParams params,
  ) {
    return repository.getFollowUps(params);
  }
}
