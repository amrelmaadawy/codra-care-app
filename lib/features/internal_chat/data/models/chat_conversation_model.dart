import '../../domain/entities/chat_conversation_entity.dart';
import 'chat_capabilities_model.dart';
import 'chat_doctor_participant_model.dart';
import 'chat_message_preview_model.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.id,
    required super.doctor,
    super.lastMessage,
    super.unreadCount = 0,
    super.capabilities = const ChatCapabilitiesModel(),
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      doctor: json['doctor'] is Map<String, dynamic>
          ? ChatDoctorParticipantModel.fromJson(
              json['doctor'] as Map<String, dynamic>,
            )
          : const ChatDoctorParticipantModel(id: 0, name: ''),
      lastMessage: json['last_message'] is Map<String, dynamic>
          ? ChatMessagePreviewModel.fromJson(
              json['last_message'] as Map<String, dynamic>,
            )
          : null,
      unreadCount: json['unread_count'] is int
          ? json['unread_count'] as int
          : int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      capabilities: json['capabilities'] is Map<String, dynamic>
          ? ChatCapabilitiesModel.fromJson(
              json['capabilities'] as Map<String, dynamic>,
            )
          : const ChatCapabilitiesModel(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor': (doctor as ChatDoctorParticipantModel).toJson(),
      'last_message': lastMessage != null
          ? (lastMessage as ChatMessagePreviewModel).toJson()
          : null,
      'unread_count': unreadCount,
      'capabilities': (capabilities as ChatCapabilitiesModel).toJson(),
    };
  }
}
