import '../../domain/entities/queue_summary_entity.dart';

class QueueSummaryModel extends QueueSummaryEntity {
  const QueueSummaryModel({
    super.waiting,
    super.withDoctor,
    super.completed,
    super.cancelled,
    super.total,
    super.avgWaitMinutes,
  });

  factory QueueSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const QueueSummaryModel();
    return QueueSummaryModel(
      waiting: (json['waiting'] as num?)?.toInt() ?? 0,
      withDoctor: (json['with_doctor'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      cancelled: (json['cancelled'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      avgWaitMinutes: (json['avg_wait_minutes'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waiting': waiting,
      'with_doctor': withDoctor,
      'completed': completed,
      'cancelled': cancelled,
      'total': total,
      'avg_wait_minutes': avgWaitMinutes,
    };
  }
}
