import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required String tenantCode,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getMe();

  Future<Either<Failure, void>> saveSession(UserEntity user, String token);

  Future<Either<Failure, UserEntity?>> getCachedUser();

  Future<Either<Failure, void>> clearSession();
}
