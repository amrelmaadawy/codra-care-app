import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'data/data_sources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/use_cases/get_me_use_case.dart';
import 'domain/use_cases/login_use_case.dart';
import 'domain/use_cases/logout_use_case.dart';
import 'presentation/cubits/auth_cubit.dart';

void setupAuthDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), const FlutterSecureStorage()),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetMeUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => AuthCubit(sl(), sl(), sl(), sl(), sl()),
  );
}
