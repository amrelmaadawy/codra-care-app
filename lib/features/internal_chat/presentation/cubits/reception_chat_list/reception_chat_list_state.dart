import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_conversation_entity.dart';

enum ReceptionChatListStatus { initial, loading, loaded, error }

class ReceptionChatListState extends Equatable {
  final ReceptionChatListStatus status;
  final List<ChatConversationEntity> chats;
  final int currentPage;
  final int lastPage;
  final bool hasMore;
  final bool isLoadingMore;
  final String searchQuery;
  final String statusFilter;
  final int totalUnread;
  final int? selectedChatId;
  final String? errorMessage;

  const ReceptionChatListState({
    this.status = ReceptionChatListStatus.initial,
    this.chats = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.statusFilter = 'all',
    this.totalUnread = 0,
    this.selectedChatId,
    this.errorMessage,
  });

  bool get isInitial => status == ReceptionChatListStatus.initial;
  bool get isLoading => status == ReceptionChatListStatus.loading;
  bool get isLoaded => status == ReceptionChatListStatus.loaded;
  bool get isError => status == ReceptionChatListStatus.error;
  bool get isEmpty => isLoaded && chats.isEmpty;

  ReceptionChatListState copyWith({
    ReceptionChatListStatus? status,
    List<ChatConversationEntity>? chats,
    int? currentPage,
    int? lastPage,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    String? statusFilter,
    int? totalUnread,
    int? selectedChatId,
    bool clearSelectedChat = false,
    String? errorMessage,
  }) {
    return ReceptionChatListState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      totalUnread: totalUnread ?? this.totalUnread,
      selectedChatId: clearSelectedChat
          ? null
          : (selectedChatId ?? this.selectedChatId),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        chats,
        currentPage,
        lastPage,
        hasMore,
        isLoadingMore,
        searchQuery,
        statusFilter,
        totalUnread,
        selectedChatId,
        errorMessage,
      ];
}
