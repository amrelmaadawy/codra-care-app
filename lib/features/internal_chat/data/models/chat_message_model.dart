import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/message_delivery_status.dart';
import 'chat_message_sender_model.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    super.clientMessageId,
    required super.sender,
    required super.body,
    required super.isRead,
    super.readAt,
    required super.createdAt,
    super.deliveryStatus = MessageDeliveryStatus.sent,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      clientMessageId: json['client_message_id']?.toString(),
      sender: ChatMessageSenderModel.fromJson(
        json['sender'] is Map<String, dynamic>
            ? json['sender'] as Map<String, dynamic>
            : null,
      ),
      body: json['body']?.toString() ?? json['message']?.toString() ?? '',
      isRead: json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read'] == '1',
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_message_id': clientMessageId,
      'sender': (sender as ChatMessageSenderModel).toJson(),
      'body': body,
      'is_read': isRead,
      'read_at': readAt,
      'created_at': createdAt,
    };
  }
}
