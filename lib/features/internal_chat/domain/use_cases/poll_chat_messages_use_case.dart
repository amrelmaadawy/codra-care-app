import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_poll_result_entity.dart';
import '../repositories/internal_chat_repository.dart';

class PollChatMessagesUseCase {
  final InternalChatRepository repository;

  const PollChatMessagesUseCase(this.repository);

  Future<Either<Failure, ChatPollResultEntity>> call({
    required int chatId,
    required int afterId,
    int limit = 50,
  }) {
    return repository.pollChatMessages(
      chatId: chatId,
      afterId: afterId,
      limit: limit,
    );
  }
}
