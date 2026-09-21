import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  static const String tokenKey = 'auth_token';
  static const String tenantCodeKey = 'tenant_code';
  static const String cachedUserKey = 'cached_user';

  const AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    required String tenantCode,
  }) async {
    try {
      final data = await _remoteDataSource.login(
        email: email,
        password: password,
        tenantCode: tenantCode,
      );
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      final token = data['token'] as String;

      await saveSession(user, token);
      return Right(user);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Allow offline logout to proceed locally
    }
    await clearSession();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final data = await _remoteDataSource.getMe();
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      await _storage.write(
        key: cachedUserKey,
        value: jsonEncode(user.toJson()),
      );
      return Right(user);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> saveSession(UserEntity user, String token) async {
    try {
      await _storage.write(key: tokenKey, value: token);
      await _storage.write(key: tenantCodeKey, value: user.tenantCode);
      final userModel = UserModel(
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        accountType: user.accountType,
        permissions: user.permissions,
        tenantCode: user.tenantCode,
        phone: user.phone,
        photoUrl: user.photoUrl,
      );
      await _storage.write(
        key: cachedUserKey,
        value: jsonEncode(userModel.toJson()),
      );
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final jsonString = await _storage.read(key: cachedUserKey);
      if (jsonString == null || jsonString.isEmpty) {
        return const Right(null);
      }
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      final user = UserModel.fromJson(jsonMap);
      return Right(user);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSession() async {
    try {
      await _storage.delete(key: tokenKey);
      await _storage.delete(key: tenantCodeKey);
      await _storage.delete(key: cachedUserKey);
      return const Right(null);
    } catch (_) {
      return const Left(CacheFailure());
    }
  }

  Failure _mapExceptionToFailure(dynamic exception) {
    if (exception is DioException && exception.error != null) {
      return _mapExceptionToFailure(exception.error);
    }
    if (exception is UnauthorizedException) {
      return const UnauthorizedFailure();
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is NotFoundException) {
      return const NotFoundFailure();
    }
    if (exception is ServerException) {
      if (exception.fieldErrors != null && exception.fieldErrors!.isNotEmpty) {
        return ValidationFailure(
          message: exception.message,
          fieldErrors: exception.fieldErrors,
        );
      }
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    return const UnexpectedFailure();
  }
}
