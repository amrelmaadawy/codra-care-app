import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_sender_type.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';
import '../../domain/entities/message_delivery_status.dart';
import '../../domain/use_cases/init_doctor_chat_use_case.dart';
import '../../domain/use_cases/mark_doctor_chat_read_use_case.dart';
import '../../domain/use_cases/poll_doctor_chat_use_case.dart';
import '../../domain/use_cases/send_doctor_chat_message_use_case.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final InitDoctorChatUseCase _initUseCase;
  final PollDoctorChatUseCase _pollUseCase;
  final SendDoctorChatMessageUseCase _sendUseCase;
  final MarkDoctorChatReadUseCase _markReadUseCase;

  Timer? _pollingTimer;
  bool _isActive = true;

  ChatCubit(
    this._initUseCase,
    this._pollUseCase,
    this._sendUseCase,
    this._markReadUseCase,
  ) : super(const ChatInitial());

  Future<void> initChat() async {
    emit(const ChatLoading());
    final result = await _initUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(ChatError(failure)),
      (data) {
        if (data.messages.isEmpty) {
          emit(ChatEmpty(chat: data.chat));
        } else {
          final firstUnread = data.messages
              .where((m) => m.isReception && !m.isRead)
              .firstOrNull
              ?.id;

          emit(ChatLoaded(
            chat: data.chat,
            messages: data.messages,
            unreadCount: data.unreadCount,
            firstUnreadMessageId: firstUnread,
          ));
        }
        _startPolling();
      },
    );
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _poll());
  }

  Future<void> _poll() async {
    final currentState = state;
    if (currentState is! ChatLoaded && currentState is! ChatEmpty) return;

    final messages = currentState is ChatLoaded ? currentState.messages : <DoctorChatMessageEntity>[];
    final lastId = messages
        .where((m) => m.deliveryStatus.isSent && m.id > 0)
        .fold<int?>(null, (max, m) => max == null || m.id > max ? m.id : max);

    final result = await _pollUseCase(afterId: lastId, isActive: _isActive);
    if (isClosed) return;

    result.fold((_) {}, (pollData) {
      if (pollData.messages.isEmpty) return;

      final updatedList = List<DoctorChatMessageEntity>.from(messages);
      for (final newMsg in pollData.messages) {
        if (!updatedList.any((m) => m.id == newMsg.id)) {
          updatedList.add(newMsg);
        }
      }

      final chat = currentState is ChatLoaded ? currentState.chat : (currentState as ChatEmpty).chat;
      emit(ChatLoaded(
        chat: chat,
        messages: updatedList,
        unreadCount: pollData.unreadCount,
        firstUnreadMessageId: currentState is ChatLoaded ? currentState.firstUnreadMessageId : null,
      ));
    });
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final currentState = state;
    if (currentState is! ChatLoaded && currentState is! ChatEmpty) return;

    final tempId = DateTime.now().microsecondsSinceEpoch.toString();
    final now = DateTime.now();
    final chat = currentState is ChatLoaded ? currentState.chat : (currentState as ChatEmpty).chat;
    final currentList = currentState is ChatLoaded ? currentState.messages : <DoctorChatMessageEntity>[];

    final optimisticMsg = DoctorChatMessageEntity(
      id: 0,
      chatId: chat.id,
      senderId: chat.doctorId,
      senderName: chat.doctorName,
      senderType: ChatSenderType.doctor,
      message: trimmed,
      isRead: false,
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      createdAt: now.toIso8601String(),
      humanTime: 'just now',
      deliveryStatus: MessageDeliveryStatus.sending,
      localTempId: tempId,
    );

    emit(ChatLoaded(
      chat: chat,
      messages: [...currentList, optimisticMsg],
      unreadCount: currentState is ChatLoaded ? currentState.unreadCount : 0,
      isSending: true,
      firstUnreadMessageId: currentState is ChatLoaded ? currentState.firstUnreadMessageId : null,
    ));

    await _executeSend(tempId, trimmed);
  }

  Future<void> retrySendMessage(DoctorChatMessageEntity failedMsg) async {
    if (failedMsg.localTempId == null || state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;

    final updated = loaded.messages.map((m) =>
      m.localTempId == failedMsg.localTempId ? m.copyWith(deliveryStatus: MessageDeliveryStatus.sending) : m
    ).toList();

    emit(loaded.copyWith(messages: updated, isSending: true, clearSendError: true));
    await _executeSend(failedMsg.localTempId!, failedMsg.message);
  }

  Future<void> _executeSend(String tempId, String text) async {
    final result = await _sendUseCase(text);
    if (isClosed || state is! ChatLoaded) return;

    final loaded = state as ChatLoaded;
    result.fold(
      (failure) {
        final failedList = loaded.messages.map((m) =>
          m.localTempId == tempId ? m.copyWith(deliveryStatus: MessageDeliveryStatus.failed) : m
        ).toList();
        emit(loaded.copyWith(messages: failedList, isSending: false, sendError: failure.message));
      },
      (sentMsg) {
        final confirmedList = loaded.messages.map((m) =>
          m.localTempId == tempId ? sentMsg.copyWith(deliveryStatus: MessageDeliveryStatus.sent) : m
        ).toList();
        emit(loaded.copyWith(messages: confirmedList, isSending: false, clearSendError: true));
      },
    );
  }

  void setScreenActive(bool active) {
    _isActive = active;
    if (active) _markReadUseCase();
  }

  void clearSendError() {
    if (state is ChatLoaded) {
      emit((state as ChatLoaded).copyWith(clearSendError: true));
    }
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
