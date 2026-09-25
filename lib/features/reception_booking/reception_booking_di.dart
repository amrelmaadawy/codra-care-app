import 'package:get_it/get_it.dart';
import 'data/datasources/reception_booking_remote_data_source.dart';
import 'data/repositories/reception_booking_repository_impl.dart';
import 'domain/repositories/reception_booking_repository.dart';
import 'domain/usecases/create_appointment_use_case.dart';
import 'domain/usecases/get_booking_form_context_use_case.dart';
import 'domain/usecases/search_patients_use_case.dart';
import 'presentation/cubits/appointment_form_cubit.dart';

void setupReceptionBookingDi([GetIt? locator]) {
  final sl = locator ?? GetIt.instance;

  // Data sources
  sl.registerLazySingleton<ReceptionBookingRemoteDataSource>(
    () => ReceptionBookingRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ReceptionBookingRepository>(
    () => ReceptionBookingRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => GetBookingFormContextUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => SearchPatientsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateAppointmentUseCase(repository: sl()));

  // Cubits
  sl.registerFactory(
    () => AppointmentFormCubit(
      getContextUseCase: sl(),
      searchPatientsUseCase: sl(),
      createAppointmentUseCase: sl(),
    ),
  );
}
