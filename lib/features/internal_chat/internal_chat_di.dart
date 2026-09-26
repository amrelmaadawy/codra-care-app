import 'package:get_it/get_it.dart';
import '../../core/network/api_client.dart';
import '../../core/services/navigation_badge_service.dart';
import 'data/data_sources/internal_chat_remote_data_source.dart';
import 'data/repositories/internal_chat_repository_impl.dart';
import 'domain/repositories/internal_chat_repository.dart';
import 'domain/use_cases/get_chat_conversation_use_case.dart';
import 'domain/use_cases/get_reception_chats_use_case.dart';
import 'domain/use_cases/get_reception_unread_count_use_case.dart';
import 'domain/use_cases/mark_chat_read_use_case.dart';
import 'domain/use_cases/poll_chat_messages_use_case.dart';
import 'domain/use_cases/send_reception_message_use_case.dart';
import 'presentation/cubits/reception_chat_list/reception_chat_list_cubit.dart';
import 'presentation/cubits/reception_conversation/reception_conversation_cubit.dart';

void setupInternalChatDi() {
  final sl = GetIt.instance;

  // Data Source
  sl.registerLazySingleton<InternalChatRemoteDataSource>(
    () => InternalChatRemoteDataSourceImpl(sl<ApiClient>()),
  );

  // Repository
  sl.registerLazySingleton<InternalChatRepository>(
    () => InternalChatRepositoryImpl(sl<InternalChatRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetReceptionChatsUseCase(sl()));
  sl.registerLazySingleton(() => GetChatConversationUseCase(sl()));
  sl.registerLazySingleton(() => PollChatMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendReceptionMessageUseCase(sl()));
  sl.registerLazySingleton(() => MarkChatReadUseCase(sl()));
  sl.registerLazySingleton(() => GetReceptionUnreadCountUseCase(sl()));

  // Cubits (Factory)
  sl.registerFactory(
    () => ReceptionChatListCubit(
      getReceptionChatsUseCase: sl(),
      getReceptionUnreadCountUseCase: sl(),
      badgeService: sl<NavigationBadgeService>(),
    ),
  );

  sl.registerFactoryParam<ReceptionConversationCubit, int, void>(
    (chatId, _) => ReceptionConversationCubit(
      chatId: chatId,
      getChatConversationUseCase: sl(),
      pollChatMessagesUseCase: sl(),
      sendReceptionMessageUseCase: sl(),
      markChatReadUseCase: sl(),
    ),
  );
}
