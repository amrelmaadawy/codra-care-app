import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_dashboard_use_case.dart';
import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorDashboardUseCase _getDoctorDashboardUseCase;
  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(minutes: 5);

  DoctorDashboardCubit(this._getDoctorDashboardUseCase)
      : super(const DoctorDashboardInitial());

  @override
  void emit(DoctorDashboardState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      refresh();
    });
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> loadDashboard() async {
    emit(const DoctorDashboardLoading());

    final result = await _getDoctorDashboardUseCase();

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorDashboardError(failure)),
      (data) {
        emit(DoctorDashboardLoaded(data));
        _startAutoRefresh();
      },
    );
  }

  Future<void> refresh() async {
    final result = await _getDoctorDashboardUseCase();

    if (isClosed) return;
    result.fold(
      (failure) {
        // If already loaded, keep existing data on background refresh failure
        if (state is! DoctorDashboardLoaded) {
          emit(DoctorDashboardError(failure));
        }
      },
      (data) => emit(DoctorDashboardLoaded(data)),
    );
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }
}
