import '../../domain/entities/appointment_today_stats_entity.dart';

class AppointmentTodayStatsModel extends AppointmentTodayStatsEntity {
  const AppointmentTodayStatsModel({
    required super.scheduled,
    required super.inConsultation,
    required super.completed,
    required super.cancelled,
  });

  const AppointmentTodayStatsModel.empty() : super.empty();

  factory AppointmentTodayStatsModel.fromJson(Map<String, dynamic> json) {
    return AppointmentTodayStatsModel(
      scheduled: (json['scheduled'] as num?)?.toInt() ?? 0,
      inConsultation: (json['in_consultation'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduled': scheduled,
      'in_consultation': inConsultation,
      'completed': completed,
      'cancelled': cancelled,
    };
  }
}
