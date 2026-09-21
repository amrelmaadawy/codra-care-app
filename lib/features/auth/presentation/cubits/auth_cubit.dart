import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/permission_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/get_me_use_case.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetMeUseCase _getMeUseCase;
  final AuthRepository _authRepository;
  final PermissionService _permissionService;

  AuthCubit(
    this._loginUseCase,
    this._logoutUseCase,
    this._getMeUseCase,
    this._authRepository,
    this._permissionService,
  ) : super(const AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    final result = await _authRepository.getCachedUser();
    result.fold(
      (failure) {
        _permissionService.clear();
        emit(const AuthUnauthenticated());
      },
      (user) {
        if (user != null) {
          _permissionService.setUser(user);
          emit(AuthAuthenticated(user));
        } else {
          _permissionService.clear();
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
    required String tenantCode,
  }) async {
    emit(const AuthLoading());
    final result = await _loginUseCase(
      email: email,
      password: password,
      tenantCode: tenantCode,
    );
    result.fold(
      (failure) {
        _permissionService.clear();
        emit(AuthError(failure));
      },
      (user) {
        _permissionService.setUser(user);
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await _logoutUseCase();
    _permissionService.clear();
    emit(const AuthUnauthenticated());
  }

  Future<void> refreshProfile() async {
    final result = await _getMeUseCase();
    result.fold(
      (failure) => null,
      (user) {
        _permissionService.setUser(user);
        emit(AuthAuthenticated(user));
      },
    );
  }
}
