import 'package:get_it/get_it.dart';
import 'data/data_sources/reception_dashboard_remote_data_source.dart';
import 'data/repositories/reception_dashboard_repository_impl.dart';
import 'domain/repositories/reception_dashboard_repository.dart';
import 'domain/use_cases/get_reception_dashboard_use_case.dart';
import 'presentation/cubits/reception_dashboard_cubit.dart';

void setupReceptionDashboardDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<ReceptionDashboardRemoteDataSource>(
    () => ReceptionDashboardRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ReceptionDashboardRepository>(
    () => ReceptionDashboardRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetReceptionDashboardUseCase(sl()));

  // Cubits
  sl.registerFactory(() => ReceptionDashboardCubit(sl()));
}
