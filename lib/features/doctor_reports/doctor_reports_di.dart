import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_reports_remote_data_source.dart';
import 'data/repositories/doctor_reports_repository_impl.dart';
import 'domain/repositories/doctor_reports_repository.dart';
import 'domain/use_cases/get_doctor_reports_use_case.dart';
import 'presentation/cubit/reports_cubit.dart';

void setupDoctorReportsDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<DoctorReportsRemoteDataSource>(
    () => DoctorReportsRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DoctorReportsRepository>(
    () => DoctorReportsRepositoryImpl(sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetDoctorReportsUseCase(sl()));

  // Cubit
  sl.registerFactory(() => ReportsCubit(sl()));
}
