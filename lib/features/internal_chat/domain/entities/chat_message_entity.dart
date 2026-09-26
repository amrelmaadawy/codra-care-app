import 'package:equatable/equatable.dart';
import 'chat_message_sender_entity.dart';
import 'chat_sender_type.dart';
import 'message_delivery_status.dart';

class ChatMessageEntity extends Equatable {
  final int id;
  final String? clientMessageId;
  final ChatMessageSenderEntity sender;
  final String body;
  final bool isRead;
  final String? readAt;
  final String createdAt;
  final MessageDeliveryStatus deliveryStatus;

  const ChatMessageEntity({
    required this.id,
    this.clientMessageId,
    required this.sender,
    required this.body,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.deliveryStatus = MessageDeliveryStatus.sent,
  });

  bool get isDoctor => sender.type == ChatSenderType.doctor;
  bool get isReception => sender.type == ChatSenderType.reception;

  ChatMessageEntity copyWith({
    int? id,
    String? clientMessageId,
    ChatMessageSenderEntity? sender,
    String? body,
    bool? isRead,
    String? readAt,
    String? createdAt,
    MessageDeliveryStatus? deliveryStatus,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      sender: sender ?? this.sender,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        clientMessageId,
        sender,
        body,
        isRead,
        readAt,
        createdAt,
        deliveryStatus,
      ];
}
