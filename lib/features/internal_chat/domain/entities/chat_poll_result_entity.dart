import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';

class ChatPollResultEntity extends Equatable {
  final List<ChatMessageEntity> messages;
  final bool hasMore;
  final int lastPollId;

  const ChatPollResultEntity({
    required this.messages,
    required this.hasMore,
    required this.lastPollId,
  });

  @override
  List<Object?> get props => [messages, hasMore, lastPollId];
}
