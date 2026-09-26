import 'package:equatable/equatable.dart';
import 'chat_sender_type.dart';

class ChatMessageSenderEntity extends Equatable {
  final int? id;
  final String? name;
  final ChatSenderType type;

  const ChatMessageSenderEntity({
    this.id,
    this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}
