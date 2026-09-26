import '../../domain/entities/chat_poll_result_entity.dart';
import 'chat_message_model.dart';

class ChatPollResultModel extends ChatPollResultEntity {
  const ChatPollResultModel({
    required super.messages,
    required super.hasMore,
    required super.lastPollId,
  });

  factory ChatPollResultModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    final List<ChatMessageModel> messagesList = [];
    if (rawMessages is List) {
      for (final item in rawMessages) {
        if (item is Map<String, dynamic>) {
          messagesList.add(ChatMessageModel.fromJson(item));
        }
      }
    }

    return ChatPollResultModel(
      messages: messagesList,
      hasMore: json['has_more'] == true ||
          json['has_more'] == 1 ||
          json['has_more'] == '1',
      lastPollId: json['last_poll_id'] is int
          ? json['last_poll_id'] as int
          : int.tryParse(json['last_poll_id']?.toString() ?? '0') ?? 0,
    );
  }
}
