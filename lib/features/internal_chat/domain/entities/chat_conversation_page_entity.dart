import 'package:equatable/equatable.dart';
import 'chat_conversation_entity.dart';
import 'chat_message_entity.dart';

class ChatConversationPageEntity extends Equatable {
  final ChatConversationEntity chat;
  final List<ChatMessageEntity> messages;
  final int? nextBeforeId;
  final bool hasOlder;
  final int totalUnread;
  final String serverTime;

  const ChatConversationPageEntity({
    required this.chat,
    required this.messages,
    this.nextBeforeId,
    required this.hasOlder,
    required this.totalUnread,
    required this.serverTime,
  });

  @override
  List<Object?> get props => [
        chat,
        messages,
        nextBeforeId,
        hasOlder,
        totalUnread,
        serverTime,
      ];
}
