import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_reports_use_case.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetDoctorReportsUseCase _getReportsUseCase;

  ReportsCubit(this._getReportsUseCase) : super(const ReportsInitial());

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String? _searchQuery;

  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  Future<void> loadReports({
    int? month,
    int? year,
    bool showLoading = true,
  }) async {
    if (month != null) _selectedMonth = month;
    if (year != null) _selectedYear = year;

    if (showLoading || state is! ReportsLoaded) {
      emit(const ReportsLoading());
    }

    final result = await _getReportsUseCase(
      month: _selectedMonth > 0 ? _selectedMonth : null,
      year: _selectedYear,
      search: _searchQuery,
    );

    result.fold(
      (failure) => emit(ReportsError(
        failure: failure,
        message: failure.message,
      )),
      (response) => emit(ReportsLoaded(
        stats: response.stats,
        chart: response.chart,
        visits: response.visits,
        currentPage: response.currentPage,
        lastPage: response.lastPage,
        totalVisits: response.totalVisits,
        perPage: response.perPage,
        selectedMonth: _selectedMonth,
        selectedYear: _selectedYear,
        searchQuery: _searchQuery,
      )),
    );
  }

  Future<void> changeMonth(int month) async {
    if (_selectedMonth == month) return;
    _selectedMonth = month;
    await loadReports(month: month, showLoading: false);
  }

  Future<void> changeYear(int year) async {
    if (_selectedYear == year) return;
    _selectedYear = year;
    await loadReports(year: year);
  }

  Future<void> search(String? query) async {
    final trimmed = query?.trim();
    if (_searchQuery == trimmed) return;
    _searchQuery = (trimmed != null && trimmed.isNotEmpty) ? trimmed : null;
    await loadReports(showLoading: false);
  }

  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! ReportsLoaded) return;
    if (!currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await _getReportsUseCase(
      month: _selectedMonth > 0 ? _selectedMonth : null,
      year: _selectedYear,
      page: nextPage,
      perPage: currentState.perPage,
      search: _searchQuery,
    );

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (response) {
        final updatedVisits = [
          ...currentState.visits,
          ...response.visits,
        ];
        emit(currentState.copyWith(
          visits: updatedVisits,
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          totalVisits: response.totalVisits,
          isLoadingMore: false,
        ));
      },
    );
  }

  void refresh() {
    loadReports(showLoading: false);
  }
}
