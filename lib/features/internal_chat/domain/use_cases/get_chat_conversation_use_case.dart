import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_conversation_page_entity.dart';
import '../repositories/internal_chat_repository.dart';

class GetChatConversationUseCase {
  final InternalChatRepository repository;

  const GetChatConversationUseCase(this.repository);

  Future<Either<Failure, ChatConversationPageEntity>> call({
    required int chatId,
    int? beforeId,
    int limit = 50,
  }) {
    return repository.getChatConversation(
      chatId: chatId,
      beforeId: beforeId,
      limit: limit,
    );
  }
}
