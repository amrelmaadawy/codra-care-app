import 'package:get_it/get_it.dart';
import 'data/datasources/appointment_remote_data_source.dart';
import 'data/repositories/appointment_repository_impl.dart';
import 'domain/repositories/appointment_repository.dart';
import 'domain/usecases/cancel_appointment_use_case.dart';
import 'domain/usecases/check_in_appointment_use_case.dart';
import 'domain/usecases/get_appointments_use_case.dart';
import 'domain/usecases/get_calendar_events_use_case.dart';
import 'presentation/cubits/appointments_cubit.dart';

void setupReceptionAppointmentsDi([GetIt? locator]) {
  final sl = locator ?? GetIt.instance;

  // Data sources
  sl.registerLazySingleton<AppointmentRemoteDataSource>(
    () => AppointmentRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAppointmentsUseCase(sl()));
  sl.registerLazySingleton(() => GetCalendarEventsUseCase(sl()));
  sl.registerLazySingleton(() => CancelAppointmentUseCase(sl()));
  sl.registerLazySingleton(() => CheckInAppointmentUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => AppointmentsCubit(
      getAppointmentsUseCase: sl(),
      getCalendarEventsUseCase: sl(),
      cancelAppointmentUseCase: sl(),
      checkInAppointmentUseCase: sl(),
    ),
  );
}
