import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/internal_chat_repository.dart';

class MarkChatReadUseCase {
  final InternalChatRepository repository;

  const MarkChatReadUseCase(this.repository);

  Future<Either<Failure, int>> call({
    required int chatId,
    required int upToMessageId,
  }) {
    return repository.markChatAsRead(
      chatId: chatId,
      upToMessageId: upToMessageId,
    );
  }
}
