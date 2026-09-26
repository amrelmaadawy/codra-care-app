import '../../domain/entities/chat_message_preview_entity.dart';
import '../../domain/entities/chat_sender_type.dart';

class ChatMessagePreviewModel extends ChatMessagePreviewEntity {
  const ChatMessagePreviewModel({
    required super.preview,
    required super.senderType,
    required super.createdAt,
  });

  factory ChatMessagePreviewModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagePreviewModel(
      preview: json['preview']?.toString() ?? '',
      senderType: ChatSenderType.fromString(
        json['sender_type']?.toString() ?? 'doctor',
      ),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preview': preview,
      'sender_type': senderType.name,
      'created_at': createdAt,
    };
  }
}
