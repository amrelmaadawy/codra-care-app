import '../../domain/entities/chat_message_sender_entity.dart';
import '../../domain/entities/chat_sender_type.dart';

class ChatMessageSenderModel extends ChatMessageSenderEntity {
  const ChatMessageSenderModel({
    super.id,
    super.name,
    required super.type,
  });

  factory ChatMessageSenderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ChatMessageSenderModel(type: ChatSenderType.doctor);
    }
    return ChatMessageSenderModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      type: ChatSenderType.fromString(
        json['type']?.toString() ?? 'doctor',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
    };
  }
}
