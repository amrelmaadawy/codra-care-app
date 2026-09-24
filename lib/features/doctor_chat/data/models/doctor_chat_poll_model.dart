import '../../domain/entities/doctor_chat_poll_entity.dart';
import 'doctor_chat_message_model.dart';

class DoctorChatPollModel extends DoctorChatPollEntity {
  const DoctorChatPollModel({
    required super.messages,
    required super.unreadCount,
  });

  factory DoctorChatPollModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'] as List<dynamic>? ?? [];

    return DoctorChatPollModel(
      messages: rawMessages
          .whereType<Map<String, dynamic>>()
          .map(DoctorChatMessageModel.fromJson)
          .toList(),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}
