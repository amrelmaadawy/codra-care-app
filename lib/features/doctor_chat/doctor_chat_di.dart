import 'package:get_it/get_it.dart';
import 'data/data_sources/doctor_chat_remote_data_source.dart';
import 'data/repositories/doctor_chat_repository_impl.dart';
import 'domain/repositories/doctor_chat_repository.dart';
import 'domain/use_cases/get_doctor_chat_unread_count_use_case.dart';
import 'domain/use_cases/init_doctor_chat_use_case.dart';
import 'domain/use_cases/mark_doctor_chat_read_use_case.dart';
import 'domain/use_cases/poll_doctor_chat_use_case.dart';
import 'domain/use_cases/send_doctor_chat_message_use_case.dart';
import 'presentation/cubit/chat_cubit.dart';

void setupDoctorChatDi() {
  final sl = GetIt.instance;

  // Data Sources
  sl.registerLazySingleton<DoctorChatRemoteDataSource>(
    () => DoctorChatRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<DoctorChatRepository>(
    () => DoctorChatRepositoryImpl(sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => InitDoctorChatUseCase(sl()));
  sl.registerLazySingleton(() => PollDoctorChatUseCase(sl()));
  sl.registerLazySingleton(() => SendDoctorChatMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkDoctorChatReadUseCase(sl()));
  sl.registerLazySingleton(() => GetDoctorChatUnreadCountUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ChatCubit(
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
}
