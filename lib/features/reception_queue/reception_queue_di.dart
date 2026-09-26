import 'package:get_it/get_it.dart';
import 'data/data_sources/reception_queue_remote_data_source.dart';
import 'data/repositories/reception_queue_repository_impl.dart';
import 'domain/repositories/reception_queue_repository.dart';
import 'domain/use_cases/call_doctor_use_case.dart';
import 'domain/use_cases/cancel_queue_item_use_case.dart';
import 'domain/use_cases/complete_queue_item_use_case.dart';
import 'domain/use_cases/get_reception_queue_use_case.dart';
import 'domain/use_cases/save_queue_vitals_use_case.dart';
import 'domain/use_cases/toggle_presence_use_case.dart';
import 'presentation/cubit/reception_queue_cubit.dart';

void setupReceptionQueueDi([GetIt? locator]) {
  final sl = locator ?? GetIt.instance;

  // Data sources
  sl.registerLazySingleton<ReceptionQueueRemoteDataSource>(
    () => ReceptionQueueRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<ReceptionQueueRepository>(
    () => ReceptionQueueRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetReceptionQueueUseCase(sl()));
  sl.registerLazySingleton(() => TogglePresenceUseCase(sl()));
  sl.registerLazySingleton(() => SaveQueueVitalsUseCase(sl()));
  sl.registerLazySingleton(() => CallDoctorUseCase(sl()));
  sl.registerLazySingleton(() => CompleteQueueItemUseCase(sl()));
  sl.registerLazySingleton(() => CancelQueueItemUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ReceptionQueueCubit(
      getQueueUseCase: sl(),
      togglePresenceUseCase: sl(),
      callDoctorUseCase: sl(),
      completeUseCase: sl(),
      cancelUseCase: sl(),
    ),
  );
}
