import 'package:get_it/get_it.dart';
import 'data/data_sources/profile_remote_data_source.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/profile_repository.dart';
import 'domain/use_cases/get_doctor_profile_use_case.dart';
import 'domain/use_cases/update_doctor_password_use_case.dart';
import 'domain/use_cases/update_doctor_photo_use_case.dart';
import 'domain/use_cases/update_doctor_profile_use_case.dart';
import 'presentation/cubits/profile_cubit.dart';

void setupProfileDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateDoctorPhotoUseCase(sl()));

  // Cubit (Factory)
  sl.registerFactory(
    () => ProfileCubit(
      getDoctorProfileUseCase: sl(),
      updateDoctorProfileUseCase: sl(),
      updateDoctorPasswordUseCase: sl(),
      updateDoctorPhotoUseCase: sl(),
    ),
  );
}
