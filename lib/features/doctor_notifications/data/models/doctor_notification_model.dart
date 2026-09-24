import '../../domain/entities/doctor_notification_entity.dart';

class DoctorNotificationModel extends DoctorNotificationEntity {
  const DoctorNotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.subtitle,
    required super.meta,
    required super.icon,
    required super.color,
    required super.timestamp,
  });

  factory DoctorNotificationModel.fromJson(Map<String, dynamic> json) {
    return DoctorNotificationModel(
      id:        json['id'],
      type:      NotificationType.fromString(json['type'] as String? ?? ''),
      title:     json['title'] as String? ?? '',
      subtitle:  json['subtitle'] as String? ?? '',
      meta:      json['meta'] as String? ?? '',
      icon:      json['icon'] as String? ?? '',
      color:     json['color'] as String? ?? '',
      timestamp: json['timestamp'] as int? ?? 0,
    );
  }
}

class DoctorNotificationsModel extends DoctorNotificationsEntity {
  const DoctorNotificationsModel({
    required super.totalUnread,
    required super.notifications,
  });

  factory DoctorNotificationsModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['recent_notifications'] as List<dynamic>? ?? [];
    return DoctorNotificationsModel(
      totalUnread: json['total_unread'] as int? ?? 0,
      notifications: rawList
          .map((e) => DoctorNotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
