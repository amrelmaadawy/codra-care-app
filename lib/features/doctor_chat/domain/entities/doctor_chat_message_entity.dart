import 'package:equatable/equatable.dart';
import 'chat_sender_type.dart';
import 'message_delivery_status.dart';

class DoctorChatMessageEntity extends Equatable {
  final int id;
  final int chatId;
  final int senderId;
  final String senderName;
  final ChatSenderType senderType;
  final String message;
  final bool isRead;
  final String? readAt;
  final String time;
  final String date;
  final String createdAt;
  final String humanTime;
  final MessageDeliveryStatus deliveryStatus;
  final String? localTempId;

  const DoctorChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.isRead,
    this.readAt,
    required this.time,
    required this.date,
    required this.createdAt,
    required this.humanTime,
    this.deliveryStatus = MessageDeliveryStatus.sent,
    this.localTempId,
  });

  bool get isDoctor => senderType.isDoctor;
  bool get isReception => senderType.isReception;

  DoctorChatMessageEntity copyWith({
    int? id,
    int? chatId,
    int? senderId,
    String? senderName,
    ChatSenderType? senderType,
    String? message,
    bool? isRead,
    String? readAt,
    String? time,
    String? date,
    String? createdAt,
    String? humanTime,
    MessageDeliveryStatus? deliveryStatus,
    String? localTempId,
  }) {
    return DoctorChatMessageEntity(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderType: senderType ?? this.senderType,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      time: time ?? this.time,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      humanTime: humanTime ?? this.humanTime,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      localTempId: localTempId ?? this.localTempId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        senderId,
        senderName,
        senderType,
        message,
        isRead,
        readAt,
        time,
        date,
        createdAt,
        humanTime,
        deliveryStatus,
        localTempId,
      ];
}
