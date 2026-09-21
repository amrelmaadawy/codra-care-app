import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_dashboard_remote_data_source.dart';
import 'data/repositories/doctor_dashboard_repository_impl.dart';
import 'domain/repositories/doctor_dashboard_repository.dart';
import 'domain/use_cases/get_doctor_dashboard_use_case.dart';
import 'presentation/cubits/doctor_dashboard_cubit.dart';

void setupDoctorDashboardDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<DoctorDashboardRemoteDataSource>(
    () => DoctorDashboardRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorDashboardRepository>(
    () => DoctorDashboardRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorDashboardUseCase(sl()));

  // Cubits
  sl.registerFactory(() => DoctorDashboardCubit(sl()));
}
