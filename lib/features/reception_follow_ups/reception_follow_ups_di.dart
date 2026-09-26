import 'package:get_it/get_it.dart';
import 'data/datasources/reception_follow_ups_remote_data_source.dart';
import 'data/repositories/reception_follow_ups_repository_impl.dart';
import 'domain/repositories/reception_follow_ups_repository.dart';
import 'domain/usecases/get_follow_ups_use_case.dart';
import 'presentation/cubits/reception_follow_ups_cubit.dart';

void setupReceptionFollowUpsDi([GetIt? locator]) {
  final sl = locator ?? GetIt.instance;

  // Data Source
  sl.registerLazySingleton<ReceptionFollowUpsRemoteDataSource>(
    () => ReceptionFollowUpsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ReceptionFollowUpsRepository>(
    () => ReceptionFollowUpsRepositoryImpl(sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetFollowUpsUseCase(sl()));

  // Cubit
  sl.registerFactory(() => ReceptionFollowUpsCubit(sl()));
}
