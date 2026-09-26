import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_follow_ups_use_case.dart';
import 'reception_follow_ups_state.dart';

class ReceptionFollowUpsCubit extends Cubit<ReceptionFollowUpsState> {
  final GetFollowUpsUseCase _getFollowUpsUseCase;
  Timer? _searchDebounce;

  ReceptionFollowUpsCubit(this._getFollowUpsUseCase)
      : super(const ReceptionFollowUpsState());

  Future<void> init() async {
    await loadFollowUps();
  }

  Future<void> loadFollowUps({bool silent = false}) async {
    final newGeneration = state.requestGeneration + 1;
    final params = state.params.copyWith(page: 1);

    if (silent) {
      emit(state.copyWith(
        isSilentRefreshing: true,
        requestGeneration: newGeneration,
        clearError: true,
      ));
    } else {
      emit(state.copyWith(
        status: FollowUpsStatus.loading,
        requestGeneration: newGeneration,
        clearError: true,
      ));
    }

    final result = await _getFollowUpsUseCase(params);

    if (state.requestGeneration != newGeneration) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: FollowUpsStatus.error,
        errorMessage: failure.message,
        isSilentRefreshing: false,
      )),
      (page) => emit(state.copyWith(
        status: FollowUpsStatus.success,
        items: page.items,
        summary: page.summary,
        params: params,
        hasMore: page.hasMore,
        isSilentRefreshing: false,
        clearError: true,
      )),
    );
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    final nextPage = state.params.page + 1;
    final params = state.params.copyWith(page: nextPage);
    final generation = state.requestGeneration;

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getFollowUpsUseCase(params);

    if (state.requestGeneration != generation) return;

    result.fold(
      (failure) => emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.message,
      )),
      (page) => emit(state.copyWith(
        isLoadingMore: false,
        items: [...state.items, ...page.items],
        summary: page.summary,
        params: params,
        hasMore: page.hasMore,
      )),
    );
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      final trimmed = query.trim();
      final newParams = trimmed.isEmpty
          ? state.params.copyWith(clearSearch: true)
          : state.params.copyWith(search: trimmed);
      emit(state.copyWith(params: newParams));
      loadFollowUps();
    });
  }

  void setUrgency(String? urgency) {
    final newParams = (urgency == null || urgency.isEmpty || urgency == 'all')
        ? state.params.copyWith(clearUrgency: true)
        : state.params.copyWith(urgency: urgency);
    emit(state.copyWith(params: newParams));
    loadFollowUps();
  }

  void setDoctorId(int? doctorId) {
    final newParams = doctorId == null
        ? state.params.copyWith(clearDoctorId: true)
        : state.params.copyWith(doctorId: doctorId);
    emit(state.copyWith(params: newParams));
    loadFollowUps();
  }

  void setDateRange(String? startDate, String? endDate) {
    final newParams = (startDate == null && endDate == null)
        ? state.params.copyWith(clearDates: true)
        : state.params.copyWith(startDate: startDate, endDate: endDate);
    emit(state.copyWith(params: newParams));
    loadFollowUps();
  }

  void toggleInstructions(int visitId) {
    final current = Set<int>.from(state.expandedItemIds);
    if (current.contains(visitId)) {
      current.remove(visitId);
    } else {
      current.add(visitId);
    }
    emit(state.copyWith(expandedItemIds: current));
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
