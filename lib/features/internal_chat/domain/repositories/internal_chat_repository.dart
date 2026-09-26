import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_conversation_page_entity.dart';
import '../entities/chat_list_result_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/chat_poll_result_entity.dart';

abstract class InternalChatRepository {
  Future<Either<Failure, ChatListResultEntity>> getReceptionChats({
    String? search,
    String? status,
    int page = 1,
    int perPage = 20,
  });

  Future<Either<Failure, ChatConversationPageEntity>> getChatConversation({
    required int chatId,
    int? beforeId,
    int limit = 50,
  });

  Future<Either<Failure, ChatPollResultEntity>> pollChatMessages({
    required int chatId,
    required int afterId,
    int limit = 50,
  });

  Future<Either<Failure, ChatMessageEntity>> sendReceptionMessage({
    required int chatId,
    required String message,
    required String clientMessageId,
  });

  Future<Either<Failure, int>> markChatAsRead({
    required int chatId,
    required int upToMessageId,
  });

  Future<Either<Failure, int>> getReceptionUnreadCount();
}
