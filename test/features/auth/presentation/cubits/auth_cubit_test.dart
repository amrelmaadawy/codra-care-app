import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/di/permission_service.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/auth/domain/entities/user_entity.dart';
import 'package:medical_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:medical_erp/features/auth/domain/use_cases/get_me_use_case.dart';
import 'package:medical_erp/features/auth/domain/use_cases/login_use_case.dart';
import 'package:medical_erp/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:medical_erp/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:medical_erp/features/auth/presentation/cubits/auth_state.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetMeUseCase extends Mock implements GetMeUseCase {}
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetMeUseCase mockGetMeUseCase;
  late MockAuthRepository mockAuthRepository;
  late PermissionService permissionService;

  const tUser = UserEntity(
    id: 1,
    name: 'Dr. John',
    email: 'doc@clinic.com',
    role: 'doctor',
    accountType: 'doctor',
    permissions: ['doctor.queue.view'],
    tenantCode: 'CL01',
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetMeUseCase = MockGetMeUseCase();
    mockAuthRepository = MockAuthRepository();
    permissionService = PermissionService();
  });

  AuthCubit buildCubit() => AuthCubit(
        mockLoginUseCase,
        mockLogoutUseCase,
        mockGetMeUseCase,
        mockAuthRepository,
        permissionService,
      );

  test('initial state should be AuthInitial', () {
    expect(buildCubit().state, const AuthInitial());
  });

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthAuthenticated] when login succeeds',
    build: () {
      when(
        () => mockLoginUseCase(
          email: 'doc@clinic.com',
          password: 'pass',
          tenantCode: 'CL01',
        ),
      ).thenAnswer((_) async => const Right(tUser));
      return buildCubit();
    },
    act: (cubit) => cubit.login(
      email: 'doc@clinic.com',
      password: 'pass',
      tenantCode: 'CL01',
    ),
    expect: () => [
      const AuthLoading(),
      const AuthAuthenticated(tUser),
    ],
    verify: (_) {
      expect(permissionService.isDoctor, isTrue);
      expect(permissionService.has('doctor.queue.view'), isTrue);
    },
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthError] when login fails',
    build: () {
      when(
        () => mockLoginUseCase(
          email: 'doc@clinic.com',
          password: 'wrong',
          tenantCode: 'CL01',
        ),
      ).thenAnswer((_) async => const Left(UnauthorizedFailure()));
      return buildCubit();
    },
    act: (cubit) => cubit.login(
      email: 'doc@clinic.com',
      password: 'wrong',
      tenantCode: 'CL01',
    ),
    expect: () => [
      const AuthLoading(),
      const AuthError(UnauthorizedFailure()),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [AuthLoading, AuthUnauthenticated] on logout',
    build: () {
      when(() => mockLogoutUseCase()).thenAnswer((_) async => const Right(null));
      return buildCubit();
    },
    act: (cubit) => cubit.logout(),
    expect: () => [
      const AuthLoading(),
      const AuthUnauthenticated(),
    ],
  );
}
