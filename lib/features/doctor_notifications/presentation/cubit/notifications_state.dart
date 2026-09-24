import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_notification_entity.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final int totalUnread;
  final List<DoctorNotificationEntity> notifications;
  final Set<String> dismissingIds; // IDs being dismissed (for optimistic UI)

  const NotificationsLoaded({
    required this.totalUnread,
    required this.notifications,
    this.dismissingIds = const {},
  });

  NotificationsLoaded copyWith({
    int? totalUnread,
    List<DoctorNotificationEntity>? notifications,
    Set<String>? dismissingIds,
  }) {
    return NotificationsLoaded(
      totalUnread: totalUnread ?? this.totalUnread,
      notifications: notifications ?? this.notifications,
      dismissingIds: dismissingIds ?? this.dismissingIds,
    );
  }

  @override
  List<Object?> get props => [totalUnread, notifications, dismissingIds];
}

class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty();
}

class NotificationsError extends NotificationsState {
  final Failure failure;

  const NotificationsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
