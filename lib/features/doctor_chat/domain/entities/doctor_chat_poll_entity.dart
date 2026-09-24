import 'package:equatable/equatable.dart';
import 'doctor_chat_message_entity.dart';

class DoctorChatPollEntity extends Equatable {
  final List<DoctorChatMessageEntity> messages;
  final int unreadCount;

  const DoctorChatPollEntity({
    required this.messages,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [messages, unreadCount];
}
