import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_queue_entity.dart';
import '../../domain/entities/queue_patient_entity.dart';

enum QueueAction { call, complete, cancel, examine }

enum QueueFilter { all, waiting, withDoctor, completed, urgent }

sealed class DoctorQueueState extends Equatable {
  const DoctorQueueState();

  @override
  List<Object?> get props => [];
}

final class DoctorQueueInitial extends DoctorQueueState {
  const DoctorQueueInitial();
}

final class DoctorQueueLoading extends DoctorQueueState {
  const DoctorQueueLoading();
}

final class DoctorQueueLoaded extends DoctorQueueState {
  final DoctorQueueEntity queue;
  final QueueFilter selectedFilter;
  final int? activeActionItemId;
  final QueueAction? activeAction;
  final String? errorMessage;
  final String? successMessage;

  const DoctorQueueLoaded({
    required this.queue,
    this.selectedFilter = QueueFilter.all,
    this.activeActionItemId,
    this.activeAction,
    this.errorMessage,
    this.successMessage,
  });

  List<QueuePatientEntity> get filteredItems {
    return switch (selectedFilter) {
      QueueFilter.all => queue.items.where((i) => !i.isCompleted).toList(),
      QueueFilter.waiting => queue.items.where((i) => i.isWaiting).toList(),
      QueueFilter.withDoctor => queue.items.where((i) => i.isWithDoctor).toList(),
      QueueFilter.completed => queue.items.where((i) => i.isCompleted).toList(),
      QueueFilter.urgent =>
          queue.items.where((i) => i.isUrgent && !i.isCompleted).toList(),
    };
  }

  DoctorQueueLoaded copyWith({
    DoctorQueueEntity? queue,
    QueueFilter? selectedFilter,
    int? activeActionItemId,
    QueueAction? activeAction,
    String? errorMessage,
    String? successMessage,
    bool clearAction = false,
    bool clearMessages = false,
  }) {
    return DoctorQueueLoaded(
      queue: queue ?? this.queue,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      activeActionItemId: clearAction ? null : (activeActionItemId ?? this.activeActionItemId),
      activeAction: clearAction ? null : (activeAction ?? this.activeAction),
      errorMessage: clearMessages ? null : errorMessage,
      successMessage: clearMessages ? null : successMessage,
    );
  }

  bool isItemActionLoading(int itemId, QueueAction action) =>
      activeActionItemId == itemId && activeAction == action;

  @override
  List<Object?> get props => [
    queue,
    selectedFilter,
    activeActionItemId,
    activeAction,
    errorMessage,
    successMessage,
  ];
}

final class DoctorQueueError extends DoctorQueueState {
  final Failure failure;
  String get message => failure.message;

  const DoctorQueueError(this.failure);

  @override
  List<Object?> get props => [failure];
}
