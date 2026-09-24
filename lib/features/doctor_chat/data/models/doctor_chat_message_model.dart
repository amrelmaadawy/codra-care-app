import '../../domain/entities/chat_sender_type.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';
import '../../domain/entities/message_delivery_status.dart';

class DoctorChatMessageModel extends DoctorChatMessageEntity {
  const DoctorChatMessageModel({
    required super.id,
    required super.chatId,
    required super.senderId,
    required super.senderName,
    required super.senderType,
    required super.message,
    required super.isRead,
    super.readAt,
    required super.time,
    required super.date,
    required super.createdAt,
    required super.humanTime,
    super.deliveryStatus = MessageDeliveryStatus.sent,
    super.localTempId,
  });

  factory DoctorChatMessageModel.fromJson(Map<String, dynamic> json) {
    return DoctorChatMessageModel(
      id: json['id'] as int? ?? 0,
      chatId: json['chat_id'] as int? ?? 0,
      senderId: json['sender_id'] as int? ?? 0,
      senderName: json['sender_name'] as String? ?? '',
      senderType: ChatSenderType.fromString(json['sender_type'] as String?),
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] as String?,
      time: json['time'] as String? ?? '',
      date: json['date'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      humanTime: json['human_time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_type': senderType.toValue(),
      'message': message,
      'is_read': isRead,
      'read_at': readAt,
      'time': time,
      'date': date,
      'created_at': createdAt,
      'human_time': humanTime,
    };
  }
}
