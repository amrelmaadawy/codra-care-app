import 'package:equatable/equatable.dart';
import '../../domain/entities/queue_filter.dart';
import '../../domain/entities/reception_queue_entity.dart';

enum ReceptionQueueStatus { initial, loading, success, error }

class ReceptionQueueState extends Equatable {
  final ReceptionQueueStatus status;
  final ReceptionQueueEntity queue;
  final QueueFilter filter;
  final Map<int, String> pendingActions;
  final String? errorMessage;
  final String? actionFeedbackKey;
  final bool isSilentRefreshing;
  final DateTime? lastRefreshedAt;

  const ReceptionQueueState({
    this.status = ReceptionQueueStatus.initial,
    this.queue = const ReceptionQueueEntity(),
    this.filter = const QueueFilter(),
    this.pendingActions = const {},
    this.errorMessage,
    this.actionFeedbackKey,
    this.isSilentRefreshing = false,
    this.lastRefreshedAt,
  });

  bool get isLoading => status == ReceptionQueueStatus.loading;
  bool get isSuccess => status == ReceptionQueueStatus.success;
  bool get isError => status == ReceptionQueueStatus.error;
  bool get isEmpty => isSuccess && queue.items.isEmpty;

  bool isItemPending(int id) => pendingActions.containsKey(id);
  String? getItemPendingAction(int id) => pendingActions[id];

  ReceptionQueueState copyWith({
    ReceptionQueueStatus? status,
    ReceptionQueueEntity? queue,
    QueueFilter? filter,
    Map<int, String>? pendingActions,
    String? Function()? errorMessage,
    String? Function()? actionFeedbackKey,
    bool? isSilentRefreshing,
    DateTime? lastRefreshedAt,
  }) {
    return ReceptionQueueState(
      status: status ?? this.status,
      queue: queue ?? this.queue,
      filter: filter ?? this.filter,
      pendingActions: pendingActions ?? this.pendingActions,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      actionFeedbackKey: actionFeedbackKey != null
          ? actionFeedbackKey()
          : this.actionFeedbackKey,
      isSilentRefreshing: isSilentRefreshing ?? this.isSilentRefreshing,
      lastRefreshedAt: lastRefreshedAt ?? this.lastRefreshedAt,
    );
  }

  @override
  List<Object?> get props => [
    status,
    queue,
    filter,
    pendingActions,
    errorMessage,
    actionFeedbackKey,
    isSilentRefreshing,
    lastRefreshedAt,
  ];
}
