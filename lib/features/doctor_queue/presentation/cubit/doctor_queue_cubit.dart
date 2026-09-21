import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/call_patient_use_case.dart';
import '../../domain/use_cases/cancel_patient_use_case.dart';
import '../../domain/use_cases/complete_patient_use_case.dart';
import '../../domain/use_cases/get_doctor_queue_use_case.dart';
import '../../../examination/domain/use_cases/start_examination_use_case.dart';
import 'doctor_queue_state.dart';

class DoctorQueueCubit extends Cubit<DoctorQueueState> {
  final GetDoctorQueueUseCase getQueueUseCase;
  final CallPatientUseCase callPatientUseCase;
  final CompletePatientUseCase completePatientUseCase;
  final CancelPatientUseCase cancelPatientUseCase;
  final StartExaminationUseCase? startExaminationUseCase;

  Timer? _pollingTimer;
  static const Duration _pollingInterval = Duration(seconds: 30);

  DoctorQueueCubit({
    required this.getQueueUseCase,
    required this.callPatientUseCase,
    required this.completePatientUseCase,
    required this.cancelPatientUseCase,
    this.startExaminationUseCase,
  }) : super(const DoctorQueueInitial());

  void startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(_pollingInterval, (_) {
      silentRefresh();
    });
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> loadQueue() async {
    emit(const DoctorQueueLoading());
    final result = await getQueueUseCase();

    if (isClosed) return;

    result.fold(
      (failure) => emit(DoctorQueueError(failure.message)),
      (queue) {
        emit(DoctorQueueLoaded(queue: queue));
        startPolling();
      },
    );
  }

  void setFilter(QueueFilter filter) {
    if (state is! DoctorQueueLoaded) return;
    final current = state as DoctorQueueLoaded;
    final newFilter = current.selectedFilter == filter ? QueueFilter.all : filter;
    emit(current.copyWith(selectedFilter: newFilter));
  }

  Future<void> silentRefresh() async {
    if (state is! DoctorQueueLoaded) return;

    final result = await getQueueUseCase();
    if (isClosed) return;

    result.fold(
      (_) {},
      (freshQueue) {
        if (state is DoctorQueueLoaded && !isClosed) {
          final current = state as DoctorQueueLoaded;
          emit(current.copyWith(queue: freshQueue, clearMessages: true));
        }
      },
    );
  }

  Future<void> callPatient(int id) async {
    if (state is! DoctorQueueLoaded) return;
    final current = state as DoctorQueueLoaded;

    emit(current.copyWith(
      activeActionItemId: id,
      activeAction: QueueAction.call,
      clearMessages: true,
    ));

    final result = await callPatientUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(
        clearAction: true,
        errorMessage: failure.message,
      )),
      (_) async {
        emit(current.copyWith(
          clearAction: true,
          successMessage: 'doctor_queue.call_success',
        ));
        await silentRefresh();
      },
    );
  }

  Future<void> completePatient(int id) async {
    if (state is! DoctorQueueLoaded) return;
    final current = state as DoctorQueueLoaded;

    emit(current.copyWith(
      activeActionItemId: id,
      activeAction: QueueAction.complete,
      clearMessages: true,
    ));

    final result = await completePatientUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(
        clearAction: true,
        errorMessage: failure.message,
      )),
      (_) async {
        emit(current.copyWith(
          clearAction: true,
          successMessage: 'doctor_queue.complete_success',
        ));
        await silentRefresh();
      },
    );
  }

  Future<void> cancelPatient(int id) async {
    if (state is! DoctorQueueLoaded) return;
    final current = state as DoctorQueueLoaded;

    emit(current.copyWith(
      activeActionItemId: id,
      activeAction: QueueAction.cancel,
      clearMessages: true,
    ));

    final result = await cancelPatientUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(current.copyWith(
        clearAction: true,
        errorMessage: failure.message,
      )),
      (_) async {
        emit(current.copyWith(
          clearAction: true,
          successMessage: 'doctor_queue.cancel_success',
        ));
        await silentRefresh();
      },
    );
  }

  Future<int?> startExamination(int id) async {
    if (startExaminationUseCase == null || state is! DoctorQueueLoaded) return null;
    final current = state as DoctorQueueLoaded;

    emit(current.copyWith(
      activeActionItemId: id,
      activeAction: QueueAction.examine,
      clearMessages: true,
    ));

    final result = await startExaminationUseCase!(id);
    if (isClosed) return null;

    return result.fold(
      (failure) {
        emit(current.copyWith(
          clearAction: true,
          errorMessage: failure.message,
        ));
        return null;
      },
      (visitId) {
        emit(current.copyWith(clearAction: true));
        return visitId;
      },
    );
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
