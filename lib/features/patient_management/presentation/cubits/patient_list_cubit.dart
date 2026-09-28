import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../domain/entities/patient_list_entity.dart';
import '../../domain/entities/patient_list_query.dart';
import '../../domain/use_cases/get_patients_use_case.dart';
import 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  final GetPatientsUseCase getPatientsUseCase;

  Timer? _debounceTimer;
  CancelToken? _cancelToken;
  int _requestGeneration = 0;

  static const Duration searchDebounceDuration = Duration(milliseconds: 350);

  PatientListCubit({required this.getPatientsUseCase})
    : super(const PatientListInitial());

  Future<void> loadInitial() async {
    await _fetchPage(const PatientListQuery());
  }

  void onSearchChanged(String rawQuery) {
    _debounceTimer?.cancel();
    final trimmed = rawQuery.trim();

    // 1-character inputs must not trigger network requests
    if (trimmed.length == 1) {
      return;
    }

    _debounceTimer = Timer(searchDebounceDuration, () {
      final searchVal = trimmed.isEmpty ? null : trimmed;
      _fetchPage(PatientListQuery(search: searchVal));
    });
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    _fetchPage(const PatientListQuery());
  }

  Future<void> refresh() async {
    if (state is PatientListLoading) return;

    final currentQuery = switch (state) {
      PatientListSuccess(:final query) => query.copyWith(page: 1),
      PatientListEmpty(:final query) => query.copyWith(page: 1),
      PatientListError(:final query) => query.copyWith(page: 1),
      _ => const PatientListQuery(),
    };

    emit(PatientListLoading(query: currentQuery, isRefresh: true));
    await _fetchPage(currentQuery, isRefresh: true);
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! PatientListSuccess ||
        !currentState.hasMore ||
        currentState.isPaginating) {
      return;
    }

    emit(currentState.copyWith(isPaginating: true, clearPaginationError: true));

    final nextPage = currentState.query.page + 1;
    final nextQuery = currentState.query.copyWith(page: nextPage);

    final result = await getPatientsUseCase(nextQuery);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(
          currentState.copyWith(
            isPaginating: false,
            paginationError: FailureMapper.mapFailureToMessage(failure),
          ),
        );
      },
      (pageData) {
        final existingIds = currentState.items.map((e) => e.id).toSet();
        final newItems = pageData.items.where(
          (e) => !existingIds.contains(e.id),
        );
        final mergedItems = <PatientListEntity>[
          ...currentState.items,
          ...newItems,
        ];

        emit(
          PatientListSuccess(
            items: mergedItems,
            query: nextQuery,
            hasMore: pageData.hasMore,
            total: pageData.total,
          ),
        );
      },
    );
  }

  Future<void> _fetchPage(
    PatientListQuery query, {
    bool isRefresh = false,
  }) async {
    _cancelToken?.cancel('new_request');
    _cancelToken = CancelToken();

    final gen = ++_requestGeneration;
    if (!isRefresh) {
      emit(PatientListLoading(query: query));
    }

    final result = await getPatientsUseCase(query, cancelToken: _cancelToken);

    if (isClosed || gen != _requestGeneration) return;

    result.fold(
      (failure) {
        emit(
          PatientListError(
            query: query,
            message: FailureMapper.mapFailureToMessage(failure),
            failure: failure,
          ),
        );
      },
      (pageData) {
        if (pageData.items.isEmpty) {
          emit(
            PatientListEmpty(
              query: query,
              isClinicEmpty: query.search == null || query.search!.isEmpty,
            ),
          );
        } else {
          emit(
            PatientListSuccess(
              items: pageData.items,
              query: query,
              hasMore: pageData.hasMore,
              total: pageData.total,
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    _cancelToken?.cancel('cubit_closed');
    return super.close();
  }
}
