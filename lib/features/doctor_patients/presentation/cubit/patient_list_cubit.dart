import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_patients_use_case.dart';
import 'patient_list_state.dart';

class PatientListCubit extends Cubit<PatientListState> {
  final GetDoctorPatientsUseCase getDoctorPatientsUseCase;

  Timer? _searchDebounce;
  String? _currentSearch;

  PatientListCubit({
    required this.getDoctorPatientsUseCase,
  }) : super(const PatientListInitial());

  Future<void> loadPatients({String? search}) async {
    emit(const PatientListLoading());

    if (search != null) {
      _currentSearch = search.trim().isEmpty ? null : search.trim();
    }

    final result = await getDoctorPatientsUseCase(
      search: _currentSearch,
    );

    result.fold(
      (failure) => emit(PatientListError(failure)),
      (resultData) {
        if (resultData.items.isEmpty) {
          emit(PatientListEmpty(searchQuery: _currentSearch));
        } else {
          emit(PatientListLoaded(
            items: resultData.items,
            currentPage: resultData.currentPage,
            lastPage: resultData.lastPage,
            total: resultData.total,
            hasMore: resultData.hasMore,
            searchQuery: _currentSearch,
            totalPatientsStat: resultData.totalPatientsStat,
          ));
        }
      },
    );
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadPatients(search: query);
    });
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! PatientListLoaded ||
        !current.hasMore ||
        current.isFetchingMore) {
      return;
    }

    emit(current.copyWith(isFetchingMore: true));

    final nextPage = current.currentPage + 1;
    final result = await getDoctorPatientsUseCase(
      page: nextPage,
      search: current.searchQuery,
    );

    result.fold(
      (failure) => emit(current.copyWith(isFetchingMore: false)),
      (resultData) {
        final updated = List.of(current.items)..addAll(resultData.items);
        emit(current.copyWith(
          items: updated,
          currentPage: resultData.currentPage,
          lastPage: resultData.lastPage,
          hasMore: resultData.hasMore,
          isFetchingMore: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
