import '../../domain/entities/chat_list_result_entity.dart';
import 'chat_conversation_model.dart';

class ChatListResultModel extends ChatListResultEntity {
  const ChatListResultModel({
    required super.chats,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.hasMore,
    required super.totalUnread,
  });

  factory ChatListResultModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final List<ChatConversationModel> chatsList = [];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          chatsList.add(ChatConversationModel.fromJson(item));
        }
      }
    }

    final meta = json['meta'] is Map<String, dynamic>
        ? json['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ChatListResultModel(
      chats: chatsList,
      currentPage: meta['current_page'] is int
          ? meta['current_page'] as int
          : int.tryParse(meta['current_page']?.toString() ?? '1') ?? 1,
      lastPage: meta['last_page'] is int
          ? meta['last_page'] as int
          : int.tryParse(meta['last_page']?.toString() ?? '1') ?? 1,
      perPage: meta['per_page'] is int
          ? meta['per_page'] as int
          : int.tryParse(meta['per_page']?.toString() ?? '20') ?? 20,
      total: meta['total'] is int
          ? meta['total'] as int
          : int.tryParse(meta['total']?.toString() ?? '0') ?? 0,
      hasMore: meta['has_more'] == true ||
          meta['has_more'] == 1 ||
          meta['has_more'] == '1',
      totalUnread: json['total_unread'] is int
          ? json['total_unread'] as int
          : int.tryParse(json['total_unread']?.toString() ?? '0') ?? 0,
    );
  }
}
