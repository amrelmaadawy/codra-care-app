import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_reception_dashboard_use_case.dart';
import 'reception_dashboard_state.dart';

class ReceptionDashboardCubit extends Cubit<ReceptionDashboardState> {
  final GetReceptionDashboardUseCase _getReceptionDashboardUseCase;
  Timer? _pollingTimer;
  int _requestSequence = 0;
  bool _isRequestInProgress = false;
  static const Duration pollingInterval = Duration(seconds: 30);

  ReceptionDashboardCubit(this._getReceptionDashboardUseCase)
    : super(const ReceptionDashboardInitial());

  Future<void> load() async {
    _cancelPolling();
    emit(const ReceptionDashboardLoading());
    await _executeFetch(null, isInitial: true);
  }

  Future<void> retry() async {
    final currentDoctorId = state is ReceptionDashboardLoaded
        ? (state as ReceptionDashboardLoaded).selectedDoctorId
        : null;
    emit(const ReceptionDashboardLoading());
    await _executeFetch(currentDoctorId, isInitial: true);
  }

  Future<void> selectDoctor(int? doctorId) async {
    final currentState = state;
    if (currentState is! ReceptionDashboardLoaded) {
      await _executeFetch(doctorId, isInitial: true);
      return;
    }

    if (currentState.selectedDoctorId == doctorId &&
        !currentState.isQueueRefreshing) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedDoctorId: doctorId,
        isQueueRefreshing: true,
        clearSelectedDoctor: doctorId == null,
        clearWarning: true,
      ),
    );

    await _executeFetch(doctorId, isQueueOnly: true);
  }

  Future<void> refresh({bool isSilent = false}) async {
    if (_isRequestInProgress) return;
    final currentDoctorId = state is ReceptionDashboardLoaded
        ? (state as ReceptionDashboardLoaded).selectedDoctorId
        : null;
    await _executeFetch(currentDoctorId, isSilent: isSilent);
  }

  Future<void> _executeFetch(
    int? doctorId, {
    bool isInitial = false,
    bool isQueueOnly = false,
    bool isSilent = false,
  }) async {
    final requestId = ++_requestSequence;
    _isRequestInProgress = true;

    final result = await _getReceptionDashboardUseCase(
      GetReceptionDashboardParams(doctorId: doctorId),
    );

    _isRequestInProgress = false;
    if (isClosed || requestId != _requestSequence) return;

    result.fold(
      (failure) {
        if (state is ReceptionDashboardLoaded) {
          final loaded = state as ReceptionDashboardLoaded;
          emit(
            loaded.copyWith(
              isQueueRefreshing: false,
              refreshWarning: failure.message,
            ),
          );
        } else {
          emit(ReceptionDashboardError(failure));
        }
      },
      (dashboardData) {
        emit(
          ReceptionDashboardLoaded(
            data: dashboardData,
            selectedDoctorId: doctorId,
          ),
        );
        _startPolling();
      },
    );
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(pollingInterval, (_) {
      if (!isClosed && !_isRequestInProgress) {
        final currentDoctorId = state is ReceptionDashboardLoaded
            ? (state as ReceptionDashboardLoaded).selectedDoctorId
            : null;
        _executeFetch(currentDoctorId, isSilent: true);
      }
    });
  }

  void _cancelPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void pausePolling() => _cancelPolling();

  void resumePolling() {
    if (state is ReceptionDashboardLoaded) {
      _startPolling();
    }
  }

  @override
  Future<void> close() {
    _cancelPolling();
    return super.close();
  }
}
