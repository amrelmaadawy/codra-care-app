import '../../domain/entities/doctor_chat_init_entity.dart';
import 'doctor_chat_message_model.dart';
import 'doctor_chat_model.dart';

class DoctorChatInitModel extends DoctorChatInitEntity {
  const DoctorChatInitModel({
    required super.chat,
    required super.messages,
    required super.unreadCount,
  });

  factory DoctorChatInitModel.fromJson(Map<String, dynamic> json) {
    final chatJson = json['chat'] as Map<String, dynamic>? ?? {};
    final rawMessages = json['messages'] as List<dynamic>? ?? [];

    return DoctorChatInitModel(
      chat: DoctorChatModel.fromJson(chatJson),
      messages: rawMessages
          .whereType<Map<String, dynamic>>()
          .map(DoctorChatMessageModel.fromJson)
          .toList(),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}
