import 'package:equatable/equatable.dart';

/// نوع الإشعار — يمثل مصدره في النظام
enum NotificationType {
  urgentCase,
  newPatient,
  chatMessage,
  doctorLeave,
  unknown;

  static NotificationType fromString(String value) => switch (value) {
        'urgent_case'  => urgentCase,
        'new_patient'  => newPatient,
        'chat_message' => chatMessage,
        'doctor_leave' => doctorLeave,
        _              => unknown,
      };

  String toApiString() => switch (this) {
        urgentCase  => 'urgent_case',
        newPatient  => 'new_patient',
        chatMessage => 'chat_message',
        doctorLeave => 'doctor_leave',
        unknown     => '',
      };
}

class DoctorNotificationEntity extends Equatable {
  final dynamic id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final String meta;
  final String icon;
  final String color;
  final int timestamp;

  const DoctorNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.icon,
    required this.color,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, type, title, subtitle, meta, icon, color, timestamp];
}

class DoctorNotificationsEntity extends Equatable {
  final int totalUnread;
  final List<DoctorNotificationEntity> notifications;

  const DoctorNotificationsEntity({
    required this.totalUnread,
    required this.notifications,
  });

  @override
  List<Object?> get props => [totalUnread, notifications];
}
