import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_queue_remote_data_source.dart';
import 'data/repositories/doctor_queue_repository_impl.dart';
import 'domain/repositories/doctor_queue_repository.dart';
import 'domain/use_cases/call_patient_use_case.dart';
import 'domain/use_cases/cancel_patient_use_case.dart';
import 'domain/use_cases/complete_patient_use_case.dart';
import 'domain/use_cases/get_doctor_queue_use_case.dart';
import 'domain/use_cases/start_queue_examination_use_case.dart';
import 'presentation/cubit/doctor_queue_cubit.dart';

void setupDoctorQueueDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<DoctorQueueRemoteDataSource>(
    () => DoctorQueueRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorQueueRepository>(
    () => DoctorQueueRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorQueueUseCase(sl()));
  sl.registerLazySingleton(() => CallPatientUseCase(sl()));
  sl.registerLazySingleton(() => CompletePatientUseCase(sl()));
  sl.registerLazySingleton(() => CancelPatientUseCase(sl()));
  sl.registerLazySingleton(() => StartQueueExaminationUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => DoctorQueueCubit(
      getQueueUseCase: sl(),
      callPatientUseCase: sl(),
      completePatientUseCase: sl(),
      cancelPatientUseCase: sl(),
      startExaminationUseCase: sl(),
    ),
  );
}
