import '../../domain/entities/chat_conversation_page_entity.dart';
import 'chat_conversation_model.dart';
import 'chat_message_model.dart';

class ChatConversationPageModel extends ChatConversationPageEntity {
  const ChatConversationPageModel({
    required super.chat,
    required super.messages,
    super.nextBeforeId,
    required super.hasOlder,
    required super.totalUnread,
    required super.serverTime,
  });

  factory ChatConversationPageModel.fromJson(Map<String, dynamic> json) {
    final chatData = json['chat'] is Map<String, dynamic>
        ? json['chat'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawMessages = json['messages'];
    final List<ChatMessageModel> messagesList = [];
    if (rawMessages is List) {
      for (final item in rawMessages) {
        if (item is Map<String, dynamic>) {
          messagesList.add(ChatMessageModel.fromJson(item));
        }
      }
    }

    final pageData = json['page'] is Map<String, dynamic>
        ? json['page'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ChatConversationPageModel(
      chat: ChatConversationModel.fromJson(chatData),
      messages: messagesList,
      nextBeforeId: pageData['next_before_id'] is int
          ? pageData['next_before_id'] as int
          : int.tryParse(pageData['next_before_id']?.toString() ?? ''),
      hasOlder: pageData['has_older'] == true ||
          pageData['has_older'] == 1 ||
          pageData['has_older'] == '1',
      totalUnread: json['total_unread'] is int
          ? json['total_unread'] as int
          : int.tryParse(json['total_unread']?.toString() ?? '0') ?? 0,
      serverTime: json['server_time']?.toString() ?? '',
    );
  }
}
