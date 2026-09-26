import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_conversation_entity.dart';
import '../../../domain/entities/chat_message_entity.dart';

enum ReceptionConversationStatus { initial, loading, loaded, error }

class ReceptionConversationState extends Equatable {
  final ReceptionConversationStatus status;
  final ChatConversationEntity? conversation;
  final List<ChatMessageEntity> messages;
  final int? nextBeforeId;
  final bool hasOlder;
  final bool isLoadingOlder;
  final bool isSending;
  final bool pollingWarning;
  final String? errorMessage;

  const ReceptionConversationState({
    this.status = ReceptionConversationStatus.initial,
    this.conversation,
    this.messages = const [],
    this.nextBeforeId,
    this.hasOlder = false,
    this.isLoadingOlder = false,
    this.isSending = false,
    this.pollingWarning = false,
    this.errorMessage,
  });

  bool get isInitial => status == ReceptionConversationStatus.initial;
  bool get isLoading => status == ReceptionConversationStatus.loading;
  bool get isLoaded => status == ReceptionConversationStatus.loaded;
  bool get isError => status == ReceptionConversationStatus.error;

  ReceptionConversationState copyWith({
    ReceptionConversationStatus? status,
    ChatConversationEntity? conversation,
    List<ChatMessageEntity>? messages,
    int? nextBeforeId,
    bool? hasOlder,
    bool? isLoadingOlder,
    bool? isSending,
    bool? pollingWarning,
    String? errorMessage,
  }) {
    return ReceptionConversationState(
      status: status ?? this.status,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      nextBeforeId: nextBeforeId ?? this.nextBeforeId,
      hasOlder: hasOlder ?? this.hasOlder,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      isSending: isSending ?? this.isSending,
      pollingWarning: pollingWarning ?? this.pollingWarning,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversation,
        messages,
        nextBeforeId,
        hasOlder,
        isLoadingOlder,
        isSending,
        pollingWarning,
        errorMessage,
      ];
}
