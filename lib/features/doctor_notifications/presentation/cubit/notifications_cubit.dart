import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/doctor_notification_entity.dart';
import '../../domain/use_cases/get_doctor_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_doctor_notifications_use_case.dart';
import '../../domain/use_cases/mark_doctor_notification_read_use_case.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetDoctorNotificationsUseCase _getUseCase;
  final MarkDoctorNotificationReadUseCase _markReadUseCase;
  final MarkAllDoctorNotificationsUseCase _markAllUseCase;

  NotificationsCubit(
    this._getUseCase,
    this._markReadUseCase,
    this._markAllUseCase,
  ) : super(const NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(const NotificationsLoading());
    final result = await _getUseCase();
    if (isClosed) return;

    result.fold(
      (failure) => emit(NotificationsError(failure)),
      (data) {
        if (data.notifications.isEmpty) {
          emit(const NotificationsEmpty());
        } else {
          emit(NotificationsLoaded(
            totalUnread: data.totalUnread,
            notifications: data.notifications,
          ));
        }
      },
    );
  }

  Future<void> refresh() => loadNotifications();

  Future<void> dismissNotification(DoctorNotificationEntity notification) async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    final dismissKey = '${notification.type.toApiString()}_${notification.id}';
    final newDismissing = {...currentState.dismissingIds, dismissKey};

    // Optimistic UI: remove from list immediately
    final updatedList = currentState.notifications
        .where((n) => n != notification)
        .toList();
    final newUnread = updatedList.isEmpty ? 0 : (currentState.totalUnread - 1).clamp(0, 9999);

    if (updatedList.isEmpty) {
      emit(const NotificationsEmpty());
    } else {
      emit(currentState.copyWith(
        notifications: updatedList,
        totalUnread: newUnread,
        dismissingIds: newDismissing,
      ));
    }

    // Fire and forget — backend updates cache
    await _markReadUseCase(type: notification.type, id: notification.id);
  }

  Future<void> dismissAll() async {
    final currentState = state;
    if (currentState is! NotificationsLoaded) return;

    // Optimistic UI: clear immediately
    emit(const NotificationsEmpty());

    final result = await _markAllUseCase();
    if (isClosed) return;

    // On failure, reload fresh data
    result.fold(
      (_) => loadNotifications(),
      (_) {},
    );
  }
}
