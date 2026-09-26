import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/reception_queue_entity.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import '../../domain/use_cases/call_doctor_use_case.dart';
import '../../domain/use_cases/cancel_queue_item_use_case.dart';
import '../../domain/use_cases/complete_queue_item_use_case.dart';
import '../../domain/use_cases/get_reception_queue_use_case.dart';
import '../../domain/use_cases/toggle_presence_use_case.dart';
import 'reception_queue_state.dart';

class ReceptionQueueCubit extends Cubit<ReceptionQueueState> {
  final GetReceptionQueueUseCase getQueueUseCase;
  final TogglePresenceUseCase togglePresenceUseCase;
  final CallDoctorUseCase callDoctorUseCase;
  final CompleteQueueItemUseCase completeUseCase;
  final CancelQueueItemUseCase cancelUseCase;

  Timer? _pollingTimer;

  ReceptionQueueCubit({
    required this.getQueueUseCase,
    required this.togglePresenceUseCase,
    required this.callDoctorUseCase,
    required this.completeUseCase,
    required this.cancelUseCase,
  }) : super(const ReceptionQueueState());

  void startAutoPolling({Duration interval = const Duration(seconds: 30)}) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => loadQueue(silent: true));
  }

  void stopAutoPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> loadQueue({bool silent = false}) async {
    emit(silent
        ? state.copyWith(isSilentRefreshing: true)
        : state.copyWith(status: ReceptionQueueStatus.loading, errorMessage: () => null));

    final result = await getQueueUseCase(state.filter);
    result.fold(
      (failure) => emit(state.copyWith(
        status: ReceptionQueueStatus.error,
        isSilentRefreshing: false,
        errorMessage: () => failure.message,
      )),
      (queue) => emit(state.copyWith(
        status: ReceptionQueueStatus.success,
        isSilentRefreshing: false,
        queue: queue,
        lastRefreshedAt: DateTime.now(),
        errorMessage: () => null,
      )),
    );
  }

  void setStatusFilter(String? status) {
    emit(state.copyWith(filter: state.filter.copyWith(status: () => status, page: 1)));
    loadQueue();
  }

  void setDoctorFilter(int? doctorId) {
    emit(state.copyWith(filter: state.filter.copyWith(doctorId: () => doctorId, page: 1)));
    loadQueue();
  }

  void setSearch(String? search) {
    emit(state.copyWith(filter: state.filter.copyWith(search: () => search, page: 1)));
    loadQueue();
  }

  Future<void> togglePresence(int id, bool isPresent) async {
    _setItemPending(id, 'presence');
    final result = await togglePresenceUseCase(id: id, isPresent: isPresent);
    _clearItemPending(id);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: () => f.message)),
      (item) => _applyItemUpdate(
        item,
        feedbackKey: isPresent
            ? 'reception_queue.presence_confirmed'
            : 'reception_queue.absence_confirmed',
      ),
    );
  }

  Future<void> callDoctor(int id) async {
    _setItemPending(id, 'call_doctor');
    final result = await callDoctorUseCase(id: id);
    _clearItemPending(id);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: () => f.message)),
      (item) => _applyItemUpdate(
        item,
        feedbackKey: 'reception_queue.patient_called_to_doctor',
      ),
    );
  }

  Future<void> completeQueueItem(int id) async {
    _setItemPending(id, 'complete');
    final result = await completeUseCase(id: id);
    _clearItemPending(id);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: () => f.message)),
      (item) => _applyItemUpdate(
        item,
        feedbackKey: 'reception_queue.visit_completed_success',
      ),
    );
  }

  Future<void> cancelQueueItem(int id, String reason) async {
    _setItemPending(id, 'cancel');
    final result = await cancelUseCase(id: id, reason: reason);
    _clearItemPending(id);
    result.fold(
      (f) => emit(state.copyWith(errorMessage: () => f.message)),
      (item) => _applyItemUpdate(
        item,
        feedbackKey: 'reception_queue.queue_item_cancelled',
      ),
    );
  }

  void onItemUpdated(ReceptionQueueItemEntity updatedItem) {
    _applyItemUpdate(updatedItem);
  }

  void clearFeedback() {
    emit(state.copyWith(
      errorMessage: () => null,
      actionFeedbackKey: () => null,
    ));
  }

  void _setItemPending(int id, String action) {
    final map = Map<int, String>.from(state.pendingActions);
    map[id] = action;
    emit(state.copyWith(pendingActions: map));
  }

  void _clearItemPending(int id) {
    final map = Map<int, String>.from(state.pendingActions);
    map.remove(id);
    emit(state.copyWith(pendingActions: map));
  }

  void _applyItemUpdate(ReceptionQueueItemEntity updatedItem, {String? feedbackKey}) {
    final updatedList = state.queue.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    emit(state.copyWith(
      queue: ReceptionQueueEntity(
        items: updatedList,
        summary: state.queue.summary,
        doctors: state.queue.doctors,
        total: state.queue.total,
        page: state.queue.page,
        perPage: state.queue.perPage,
        lastPage: state.queue.lastPage,
      ),
      actionFeedbackKey: feedbackKey != null ? () => feedbackKey : null,
    ));
  }

  @override
  Future<void> close() {
    stopAutoPolling();
    return super.close();
  }
}
