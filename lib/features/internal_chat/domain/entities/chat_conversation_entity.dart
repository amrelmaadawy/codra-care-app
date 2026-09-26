import 'package:equatable/equatable.dart';
import 'chat_capabilities_entity.dart';
import 'chat_doctor_participant_entity.dart';
import 'chat_message_preview_entity.dart';

class ChatConversationEntity extends Equatable {
  final int id;
  final ChatDoctorParticipantEntity doctor;
  final ChatMessagePreviewEntity? lastMessage;
  final int unreadCount;
  final ChatCapabilitiesEntity capabilities;

  const ChatConversationEntity({
    required this.id,
    required this.doctor,
    this.lastMessage,
    this.unreadCount = 0,
    this.capabilities = const ChatCapabilitiesEntity(),
  });

  ChatConversationEntity copyWith({
    int? id,
    ChatDoctorParticipantEntity? doctor,
    ChatMessagePreviewEntity? lastMessage,
    int? unreadCount,
    ChatCapabilitiesEntity? capabilities,
  }) {
    return ChatConversationEntity(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      capabilities: capabilities ?? this.capabilities,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctor,
        lastMessage,
        unreadCount,
        capabilities,
      ];
}
