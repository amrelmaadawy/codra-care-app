import '../../domain/entities/appointment_calendar_day_entity.dart';

class AppointmentCalendarDayModel extends AppointmentCalendarDayEntity {
  const AppointmentCalendarDayModel({
    required super.date,
    required super.total,
    super.scheduledCount = 0,
    super.inConsultationCount = 0,
    super.completedCount = 0,
    super.cancelledCount = 0,
  });

  factory AppointmentCalendarDayModel.fromJson(Map<String, dynamic> json) {
    final statusCounts = json['status_counts'] as Map<String, dynamic>? ?? {};

    return AppointmentCalendarDayModel(
      date: (json['date'] as String?) ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      scheduledCount: (statusCounts['scheduled'] as num?)?.toInt() ?? 0,
      inConsultationCount:
          (statusCounts['in_consultation'] as num?)?.toInt() ?? 0,
      completedCount: (statusCounts['completed'] as num?)?.toInt() ?? 0,
      cancelledCount: (statusCounts['cancelled'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total': total,
      'status_counts': {
        'scheduled': scheduledCount,
        'in_consultation': inConsultationCount,
        'completed': completedCount,
        'cancelled': cancelledCount,
      },
    };
  }
}
