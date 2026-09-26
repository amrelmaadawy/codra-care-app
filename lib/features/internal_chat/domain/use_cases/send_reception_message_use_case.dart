import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/internal_chat_repository.dart';

class SendReceptionMessageUseCase {
  final InternalChatRepository repository;

  const SendReceptionMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessageEntity>> call({
    required int chatId,
    required String message,
    required String clientMessageId,
  }) {
    return repository.sendReceptionMessage(
      chatId: chatId,
      message: message,
      clientMessageId: clientMessageId,
    );
  }
}
