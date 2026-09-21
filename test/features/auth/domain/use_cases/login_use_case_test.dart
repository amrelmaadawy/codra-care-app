import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/error/failures.dart';
import 'package:medical_erp/features/auth/domain/entities/user_entity.dart';
import 'package:medical_erp/features/auth/domain/repositories/auth_repository.dart';
import 'package:medical_erp/features/auth/domain/use_cases/login_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  const tEmail = 'doctor@clinic.com';
  const tPassword = 'password123';
  const tTenantCode = 'CLINIC01';

  const tUser = UserEntity(
    id: 1,
    name: 'Dr. John Doe',
    email: tEmail,
    role: 'doctor',
    accountType: 'doctor',
    permissions: ['doctor.queue.view'],
    tenantCode: tTenantCode,
  );

  test('should return UserEntity when repository call is successful', () async {
    when(
      () => mockRepository.login(
        email: tEmail,
        password: tPassword,
        tenantCode: tTenantCode,
      ),
    ).thenAnswer((_) async => const Right(tUser));

    final result = await useCase(
      email: tEmail,
      password: tPassword,
      tenantCode: tTenantCode,
    );

    expect(result, const Right(tUser));
    verify(
      () => mockRepository.login(
        email: tEmail,
        password: tPassword,
        tenantCode: tTenantCode,
      ),
    ).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return Failure when repository call fails', () async {
    const tFailure = UnauthorizedFailure();
    when(
      () => mockRepository.login(
        email: tEmail,
        password: tPassword,
        tenantCode: tTenantCode,
      ),
    ).thenAnswer((_) async => const Left(tFailure));

    final result = await useCase(
      email: tEmail,
      password: tPassword,
      tenantCode: tTenantCode,
    );

    expect(result, const Left(tFailure));
    verify(
      () => mockRepository.login(
        email: tEmail,
        password: tPassword,
        tenantCode: tTenantCode,
      ),
    ).called(1);
  });
}
