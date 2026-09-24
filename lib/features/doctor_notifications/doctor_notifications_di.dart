import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_notifications_remote_data_source.dart';
import 'data/repositories/doctor_notifications_repository_impl.dart';
import 'domain/repositories/doctor_notifications_repository.dart';
import 'domain/use_cases/get_doctor_notifications_use_case.dart';
import 'domain/use_cases/mark_all_doctor_notifications_use_case.dart';
import 'domain/use_cases/mark_doctor_notification_read_use_case.dart';
import 'presentation/cubit/notifications_cubit.dart';

void setupDoctorNotificationsDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<DoctorNotificationsRemoteDataSource>(
    () => DoctorNotificationsRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorNotificationsRepository>(
    () => DoctorNotificationsRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetDoctorNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkDoctorNotificationReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllDoctorNotificationsUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => NotificationsCubit(sl(), sl(), sl()),
  );
}
