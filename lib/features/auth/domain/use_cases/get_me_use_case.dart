import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetMeUseCase {
  final AuthRepository _repository;

  const GetMeUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() {
    return _repository.getMe();
  }
}
