import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/exceptions.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:medical_erp/features/auth/data/models/user_model.dart';
import 'package:medical_erp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockSecureStorage = MockFlutterSecureStorage();
    repository = AuthRepositoryImpl(mockRemoteDataSource, mockSecureStorage);
  });

  const tUserModel = UserModel(
    id: 1,
    name: 'Doctor Test',
    email: 'doc@test.com',
    role: 'doctor',
    accountType: 'doctor',
    permissions: ['doctor.queue.view'],
    tenantCode: 'TEST01',
  );

  final tRemoteResponse = {
    'token': 'mock_jwt_token',
    'user': tUserModel.toJson(),
  };

  group('login', () {
    test('should return UserEntity and save session when remote succeeds', () async {
      when(
        () => mockRemoteDataSource.login(
          email: 'doc@test.com',
          password: 'pass',
          tenantCode: 'TEST01',
        ),
      ).thenAnswer((_) async => tRemoteResponse);

      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => {});

      final result = await repository.login(
        email: 'doc@test.com',
        password: 'pass',
        tenantCode: 'TEST01',
      );

      expect(result, const Right(tUserModel));
      verify(() => mockSecureStorage.write(key: 'auth_token', value: 'mock_jwt_token')).called(1);
      verify(() => mockSecureStorage.write(key: 'tenant_code', value: 'TEST01')).called(1);
    });

    test('should return UnauthorizedFailure when remote throws UnauthorizedException', () async {
      when(
        () => mockRemoteDataSource.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          tenantCode: any(named: 'tenantCode'),
        ),
      ).thenThrow(const UnauthorizedException());

      final result = await repository.login(
        email: 'doc@test.com',
        password: 'wrong',
        tenantCode: 'TEST01',
      );

      expect(result, const Left(UnauthorizedFailure()));
    });
  });

  group('getCachedUser', () {
    test('should return UserModel when cached data exists in storage', () async {
      when(() => mockSecureStorage.read(key: 'cached_user'))
          .thenAnswer((_) async => jsonEncode(tUserModel.toJson()));

      final result = await repository.getCachedUser();

      expect(result, const Right(tUserModel));
    });

    test('should return null when no cached data exists', () async {
      when(() => mockSecureStorage.read(key: 'cached_user'))
          .thenAnswer((_) async => null);

      final result = await repository.getCachedUser();

      expect(result, const Right(null));
    });
  });
}
