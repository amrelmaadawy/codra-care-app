import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/delete_prescription_use_case.dart';
import '../../domain/use_cases/get_prescriptions_use_case.dart';
import 'prescription_list_state.dart';

class PrescriptionListCubit extends Cubit<PrescriptionListState> {
  final GetPrescriptionsUseCase getPrescriptionsUseCase;
  final DeletePrescriptionUseCase deletePrescriptionUseCase;

  Timer? _searchDebounce;
  String? _currentSearch;
  bool? _currentFilterPrinted;

  PrescriptionListCubit({
    required this.getPrescriptionsUseCase,
    required this.deletePrescriptionUseCase,
  }) : super(const PrescriptionListInitial());

  @override
  void emit(PrescriptionListState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> loadPrescriptions({
    String? search,
    bool? filterPrinted,
    bool resetFilter = false,
  }) async {
    emit(const PrescriptionListLoading());

    if (resetFilter) {
      _currentFilterPrinted = null;
    } else if (filterPrinted != null) {
      _currentFilterPrinted = filterPrinted;
    }

    if (search != null) {
      _currentSearch = search.trim().isEmpty ? null : search.trim();
    }

    final result = await getPrescriptionsUseCase(
      search: _currentSearch,
      isPrinted: _currentFilterPrinted,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(PrescriptionListError(failure)),
      (paginated) {
        if (paginated.items.isEmpty) {
          emit(PrescriptionListEmpty(
            searchQuery: _currentSearch,
            filterPrinted: _currentFilterPrinted,
          ));
        } else {
          emit(PrescriptionListLoaded(
            items: paginated.items,
            currentPage: paginated.currentPage,
            lastPage: paginated.lastPage,
            total: paginated.total,
            hasMore: paginated.hasMorePages,
            searchQuery: _currentSearch,
            filterPrinted: _currentFilterPrinted,
          ));
        }
      },
    );
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!isClosed) {
        loadPrescriptions(search: query);
      }
    });
  }

  void setFilterPrinted(bool? isPrinted) {
    _currentFilterPrinted = isPrinted;
    loadPrescriptions(
      filterPrinted: isPrinted,
      resetFilter: isPrinted == null,
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! PrescriptionListLoaded ||
        !current.hasMore ||
        current.isFetchingMore) {
      return;
    }

    emit(current.copyWith(isFetchingMore: true));

    final nextPage = current.currentPage + 1;
    final result = await getPrescriptionsUseCase(
      page: nextPage,
      search: current.searchQuery,
      isPrinted: current.filterPrinted,
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(isFetchingMore: false)),
      (paginated) {
        final updated = List.of(current.items)..addAll(paginated.items);
        emit(current.copyWith(
          items: updated,
          currentPage: paginated.currentPage,
          lastPage: paginated.lastPage,
          total: paginated.total,
          hasMore: paginated.hasMorePages,
          isFetchingMore: false,
        ));
      },
    );
  }

  Future<bool> deletePrescription(int id) async {
    final result = await deletePrescriptionUseCase(id);
    if (isClosed) return false;
    return result.fold(
      (failure) => false,
      (_) {
        final current = state;
        if (current is PrescriptionListLoaded) {
          final updated = current.items.where((e) => e.id != id).toList();
          if (updated.isEmpty) {
            emit(PrescriptionListEmpty(
              searchQuery: current.searchQuery,
              filterPrinted: current.filterPrinted,
            ));
          } else {
            emit(current.copyWith(
              items: updated,
              total: current.total > 0 ? current.total - 1 : 0,
            ));
          }
        }
        return true;
      },
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
