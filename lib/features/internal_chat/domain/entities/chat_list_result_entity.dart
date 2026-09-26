import 'package:equatable/equatable.dart';
import 'chat_conversation_entity.dart';

class ChatListResultEntity extends Equatable {
  final List<ChatConversationEntity> chats;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;
  final int totalUnread;

  const ChatListResultEntity({
    required this.chats,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
    required this.totalUnread,
  });

  @override
  List<Object?> get props => [
        chats,
        currentPage,
        lastPage,
        perPage,
        total,
        hasMore,
        totalUnread,
      ];
}
