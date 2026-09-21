import '../../domain/entities/queue_summary_entity.dart';

class QueueSummaryModel extends QueueSummaryEntity {
  const QueueSummaryModel({
    required super.completedToday,
    required super.waitingCount,
    required super.withDoctorCount,
    required super.totalActive,
    required super.urgentCount,
    required super.hasUrgent,
  });

  factory QueueSummaryModel.fromJson(Map<String, dynamic> json) {
    return QueueSummaryModel(
      completedToday: (json['completed_today'] as num?)?.toInt() ?? 0,
      waitingCount: (json['waiting_count'] as num?)?.toInt() ?? 0,
      withDoctorCount: (json['with_doctor_count'] as num?)?.toInt() ?? 0,
      totalActive: (json['total_active'] as num?)?.toInt() ?? 0,
      urgentCount: (json['urgent_count'] as num?)?.toInt() ?? 0,
      hasUrgent: json['has_urgent'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completed_today': completedToday,
      'waiting_count': waitingCount,
      'with_doctor_count': withDoctorCount,
      'total_active': totalActive,
      'urgent_count': urgentCount,
      'has_urgent': hasUrgent,
    };
  }
}
