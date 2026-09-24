import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_chat_entity.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatEmpty extends ChatState {
  final DoctorChatEntity chat;

  const ChatEmpty({required this.chat});

  @override
  List<Object?> get props => [chat];
}

class ChatLoaded extends ChatState {
  final DoctorChatEntity chat;
  final List<DoctorChatMessageEntity> messages;
  final int unreadCount;
  final bool isSending;
  final int? firstUnreadMessageId;
  final String? sendError;

  const ChatLoaded({
    required this.chat,
    required this.messages,
    required this.unreadCount,
    this.isSending = false,
    this.firstUnreadMessageId,
    this.sendError,
  });

  ChatLoaded copyWith({
    DoctorChatEntity? chat,
    List<DoctorChatMessageEntity>? messages,
    int? unreadCount,
    bool? isSending,
    int? firstUnreadMessageId,
    String? sendError,
    bool clearSendError = false,
    bool clearUnreadDivider = false,
  }) {
    return ChatLoaded(
      chat: chat ?? this.chat,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
      isSending: isSending ?? this.isSending,
      firstUnreadMessageId: clearUnreadDivider
          ? null
          : (firstUnreadMessageId ?? this.firstUnreadMessageId),
      sendError: clearSendError ? null : (sendError ?? this.sendError),
    );
  }

  @override
  List<Object?> get props => [
        chat,
        messages,
        unreadCount,
        isSending,
        firstUnreadMessageId,
        sendError,
      ];
}

class ChatError extends ChatState {
  final Failure failure;

  const ChatError(this.failure);

  @override
  List<Object?> get props => [failure];
}
