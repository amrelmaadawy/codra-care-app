import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_leave_day_remote_data_source.dart';
import 'data/repositories/doctor_leave_day_repository_impl.dart';
import 'domain/repositories/doctor_leave_day_repository.dart';
import 'domain/use_cases/add_leave_day_use_case.dart';
import 'domain/use_cases/check_appointments_conflict_use_case.dart';
import 'domain/use_cases/delete_leave_day_use_case.dart';
import 'domain/use_cases/get_leave_days_summary_use_case.dart';
import 'presentation/cubit/leave_days_cubit.dart';

void setupDoctorLeaveDaysDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<DoctorLeaveDayRemoteDataSource>(
    () => DoctorLeaveDayRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DoctorLeaveDayRepository>(
    () => DoctorLeaveDayRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetLeaveDaysSummaryUseCase(sl()));
  sl.registerLazySingleton(() => AddLeaveDayUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLeaveDayUseCase(sl()));
  sl.registerLazySingleton(() => CheckAppointmentsConflictUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => LeaveDaysCubit(
      getSummaryUseCase: sl(),
      addLeaveDayUseCase: sl(),
      deleteLeaveDayUseCase: sl(),
      checkConflictUseCase: sl(),
    ),
  );
}
