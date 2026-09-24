import 'package:equatable/equatable.dart';
import 'doctor_chat_entity.dart';
import 'doctor_chat_message_entity.dart';

class DoctorChatInitEntity extends Equatable {
  final DoctorChatEntity chat;
  final List<DoctorChatMessageEntity> messages;
  final int unreadCount;

  const DoctorChatInitEntity({
    required this.chat,
    required this.messages,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [chat, messages, unreadCount];
}
