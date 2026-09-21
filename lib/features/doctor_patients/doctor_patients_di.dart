import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_patients_remote_data_source.dart';
import 'data/repositories/doctor_patients_repository_impl.dart';
import 'domain/repositories/doctor_patients_repository.dart';
import 'domain/use_cases/get_doctor_patients_use_case.dart';
import 'domain/use_cases/get_patient_detail_use_case.dart';
import 'presentation/cubit/patient_detail_cubit.dart';
import 'presentation/cubit/patient_list_cubit.dart';

void setupDoctorPatientsDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<DoctorPatientsRemoteDataSource>(
    () => DoctorPatientsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorPatientsRepository>(
    () => DoctorPatientsRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorPatientsUseCase(sl()));
  sl.registerLazySingleton(() => GetPatientDetailUseCase(sl()));

  // Cubits (Factory)
  sl.registerFactory(
    () => PatientListCubit(
      getDoctorPatientsUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => PatientDetailCubit(
      getPatientDetailUseCase: sl(),
    ),
  );
}
