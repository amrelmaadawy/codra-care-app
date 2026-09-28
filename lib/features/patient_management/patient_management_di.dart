import 'package:get_it/get_it.dart';
import 'data/data_sources/patient_remote_data_source.dart';
import 'data/repositories/patient_repository_impl.dart';
import 'domain/repositories/patient_repository.dart';
import 'domain/use_cases/get_patients_use_case.dart';
import 'presentation/cubits/patient_list_cubit.dart';

void initPatientManagementDi(GetIt sl) {
  // Data sources
  sl.registerLazySingleton<PatientRemoteDataSource>(
    () => PatientRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<PatientRepository>(
    () => PatientRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton<GetPatientsUseCase>(() => GetPatientsUseCase(sl()));

  // Cubits (Factory - per route navigation)
  sl.registerFactory<PatientListCubit>(
    () => PatientListCubit(getPatientsUseCase: sl()),
  );
}
