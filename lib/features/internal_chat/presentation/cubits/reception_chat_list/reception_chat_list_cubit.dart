import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_erp/core/error/failure_mapper.dart';
import 'package:medical_erp/core/services/navigation_badge_service.dart';
import '../../../domain/use_cases/get_reception_chats_use_case.dart';
import '../../../domain/use_cases/get_reception_unread_count_use_case.dart';
import 'reception_chat_list_state.dart';

class ReceptionChatListCubit extends Cubit<ReceptionChatListState> {
  final GetReceptionChatsUseCase getReceptionChatsUseCase;
  final GetReceptionUnreadCountUseCase getReceptionUnreadCountUseCase;
  final NavigationBadgeService badgeService;

  Timer? _pollingTimer;
  Timer? _debounceTimer;
  bool _isFetching = false;

  ReceptionChatListCubit({
    required this.getReceptionChatsUseCase,
    required this.getReceptionUnreadCountUseCase,
    required this.badgeService,
  }) : super(const ReceptionChatListState());

  void selectChat(int? chatId) {
    emit(state.copyWith(
      selectedChatId: chatId,
      clearSelectedChat: chatId == null,
    ));
  }

  Future<void> loadChats({bool isRefresh = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (!isRefresh && state.isInitial) {
      emit(state.copyWith(status: ReceptionChatListStatus.loading));
    }

    final result = await getReceptionChatsUseCase(
      search: state.searchQuery,
      status: state.statusFilter,
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: ReceptionChatListStatus.error,
          errorMessage: FailureMapper.mapFailureToMessage(failure),
        ));
      },
      (data) {
        badgeService.updateBadge(
          'reception_internal_chat',
          data.totalUnread,
        );
        emit(state.copyWith(
          status: ReceptionChatListStatus.loaded,
          chats: data.chats,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          hasMore: data.hasMore,
          totalUnread: data.totalUnread,
        ));
      },
    );
  }

  Future<void> loadMore() async {
    if (_isFetching || !state.hasMore || state.isLoadingMore) return;
    _isFetching = true;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await getReceptionChatsUseCase(
      search: state.searchQuery,
      status: state.statusFilter,
      page: nextPage,
    );

    _isFetching = false;
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (data) {
        badgeService.updateBadge(
          'reception_internal_chat',
          data.totalUnread,
        );
        emit(state.copyWith(
          isLoadingMore: false,
          chats: [...state.chats, ...data.chats],
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          hasMore: data.hasMore,
          totalUnread: data.totalUnread,
        ));
      },
    );
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (isClosed) return;
      emit(state.copyWith(searchQuery: query.trim(), currentPage: 1));
      loadChats(isRefresh: true);
    });
  }

  void onStatusFilterChanged(String status) {
    if (state.statusFilter == status) return;
    emit(state.copyWith(statusFilter: status, currentPage: 1));
    loadChats(isRefresh: true);
  }

  void startPolling() {
    stopPolling();
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (isClosed || _isFetching) return;
      _pollSilent();
    });
  }

  Future<void> _pollSilent() async {
    final result = await getReceptionChatsUseCase(
      search: state.searchQuery,
      status: state.statusFilter,
    );
    if (isClosed) return;

    result.fold(
      (_) => null,
      (data) {
        badgeService.updateBadge(
          'reception_internal_chat',
          data.totalUnread,
        );
        emit(state.copyWith(
          chats: data.chats,
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          hasMore: data.hasMore,
          totalUnread: data.totalUnread,
        ));
      },
    );
  }

  Future<void> updateUnreadCount() async {
    final result = await getReceptionUnreadCountUseCase();
    if (isClosed) return;
    result.fold(
      (_) => null,
      (count) {
        badgeService.updateBadge('reception_internal_chat', count);
        emit(state.copyWith(totalUnread: count));
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
    _debounceTimer?.cancel();
    return super.close();
  }
}
