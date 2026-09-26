import 'package:equatable/equatable.dart';
import 'chat_sender_type.dart';

class ChatMessagePreviewEntity extends Equatable {
  final String preview;
  final ChatSenderType senderType;
  final String createdAt;

  const ChatMessagePreviewEntity({
    required this.preview,
    required this.senderType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [preview, senderType, createdAt];
}
