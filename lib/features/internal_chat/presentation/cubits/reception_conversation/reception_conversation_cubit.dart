import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_erp/core/error/failure_mapper.dart';
import 'package:medical_erp/core/utils/uuid_generator.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/entities/chat_message_sender_entity.dart';
import '../../../domain/entities/chat_sender_type.dart';
import '../../../domain/entities/message_delivery_status.dart';
import '../../../domain/use_cases/get_chat_conversation_use_case.dart';
import '../../../domain/use_cases/mark_chat_read_use_case.dart';
import '../../../domain/use_cases/poll_chat_messages_use_case.dart';
import '../../../domain/use_cases/send_reception_message_use_case.dart';
import 'reception_conversation_state.dart';

class ReceptionConversationCubit extends Cubit<ReceptionConversationState> {
  final int chatId;
  final GetChatConversationUseCase getChatConversationUseCase;
  final PollChatMessagesUseCase pollChatMessagesUseCase;
  final SendReceptionMessageUseCase sendReceptionMessageUseCase;
  final MarkChatReadUseCase markChatReadUseCase;
  Timer? _pollingTimer;
  bool _isPolling = false;

  ReceptionConversationCubit({
    required this.chatId,
    required this.getChatConversationUseCase,
    required this.pollChatMessagesUseCase,
    required this.sendReceptionMessageUseCase,
    required this.markChatReadUseCase,
  }) : super(const ReceptionConversationState());

  Future<void> loadInitial() async {
    emit(state.copyWith(status: ReceptionConversationStatus.loading));
    final result = await getChatConversationUseCase(chatId: chatId);
    if (isClosed) return;
    result.fold(
      (f) => emit(state.copyWith(
        status: ReceptionConversationStatus.error,
        errorMessage: FailureMapper.mapFailureToMessage(f),
      )),
      (page) {
        emit(state.copyWith(
          status: ReceptionConversationStatus.loaded,
          conversation: page.chat,
          messages: page.messages,
          nextBeforeId: page.nextBeforeId,
          hasOlder: page.hasOlder,
        ));
        _markReadIfNeeded(page.messages);
      },
    );
  }

  Future<void> loadOlderMessages() async {
    if (!state.hasOlder || state.isLoadingOlder || state.nextBeforeId == null) {
      return;
    }
    emit(state.copyWith(isLoadingOlder: true));

    final result = await getChatConversationUseCase(
      chatId: chatId,
      beforeId: state.nextBeforeId,
    );
    if (isClosed) return;

    result.fold(
      (_) => emit(state.copyWith(isLoadingOlder: false)),
      (page) {
        final existing = state.messages.map((m) => m.id).toSet();
        final older = page.messages.where((m) => !existing.contains(m.id));
        emit(state.copyWith(
          isLoadingOlder: false,
          messages: [...older, ...state.messages],
          nextBeforeId: page.nextBeforeId,
          hasOlder: page.hasOlder,
        ));
      },
    );
  }

  Future<void> sendMessage(String text, {String? retryClientMessageId}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final clientMsgId = retryClientMessageId ?? UuidGenerator.generate();
    if (retryClientMessageId == null) {
      final optMsg = ChatMessageEntity(
        id: -DateTime.now().millisecondsSinceEpoch,
        clientMessageId: clientMsgId,
        sender: const ChatMessageSenderEntity(type: ChatSenderType.reception),
        body: trimmed,
        isRead: false,
        createdAt: DateTime.now().toUtc().toIso8601String(),
        deliveryStatus: MessageDeliveryStatus.sending,
      );
      emit(state.copyWith(messages: [...state.messages, optMsg], isSending: true));
    } else {
      _updateMsg(clientMsgId, status: MessageDeliveryStatus.sending);
    }

    final result = await sendReceptionMessageUseCase(
      chatId: chatId,
      message: trimmed,
      clientMessageId: clientMsgId,
    );
    if (isClosed) return;

    result.fold(
      (_) => _updateMsg(clientMsgId, status: MessageDeliveryStatus.failed),
      (sentMsg) => _updateMsg(clientMsgId, replacement: sentMsg),
    );
  }

  Future<void> retryFailedMessage(ChatMessageEntity msg) async {
    await sendMessage(msg.body, retryClientMessageId: msg.clientMessageId);
  }

  void _updateMsg(String clientMsgId, {
    MessageDeliveryStatus? status,
    ChatMessageEntity? replacement,
  }) {
    emit(state.copyWith(
      isSending: false,
      messages: state.messages.map((m) {
        if (m.clientMessageId != clientMsgId) return m;
        return replacement ??
            (status != null ? m.copyWith(deliveryStatus: status) : m);
      }).toList(),
    ));
  }

  void _markReadIfNeeded(List<ChatMessageEntity> messages) {
    final unread = messages.where((m) => m.isDoctor && !m.isRead && m.id > 0);
    if (unread.isNotEmpty) {
      final maxId = unread.map((m) => m.id).reduce((a, b) => a > b ? a : b);
      markChatReadUseCase(chatId: chatId, upToMessageId: maxId);
    }
  }

  void startPolling() {
    stopPolling();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (isClosed || _isPolling) return;
      _pollNewMessages();
    });
  }

  Future<void> _pollNewMessages() async {
    if (state.messages.isEmpty) return;
    final last = state.messages.lastWhere(
      (m) => m.id > 0,
      orElse: () => state.messages.last,
    );
    if (last.id <= 0) return;

    _isPolling = true;
    final result = await pollChatMessagesUseCase(
      chatId: chatId,
      afterId: last.id,
    );
    _isPolling = false;
    if (isClosed) return;

    result.fold(
      (_) => emit(state.copyWith(pollingWarning: true)),
      (pollResult) {
        if (pollResult.messages.isEmpty) {
          if (state.pollingWarning) emit(state.copyWith(pollingWarning: false));
          return;
        }

        final existing = state.messages.map((m) => m.id).toSet();
        final newMsgs = pollResult.messages
            .where((m) => !existing.contains(m.id))
            .toList();

        if (newMsgs.isNotEmpty) {
          emit(state.copyWith(
            messages: [...state.messages, ...newMsgs],
            pollingWarning: false,
          ));
          _markReadIfNeeded(newMsgs);
        }
      },
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
