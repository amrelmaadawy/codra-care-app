import '../../domain/entities/doctor_queue_entity.dart';
import 'queue_patient_model.dart';
import 'queue_summary_model.dart';

class DoctorQueueModel extends DoctorQueueEntity {
  const DoctorQueueModel({
    required super.items,
    required super.summary,
  });

  factory DoctorQueueModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((e) => QueuePatientModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final summaryJson = json['summary'] is Map<String, dynamic>
        ? json['summary'] as Map<String, dynamic>
        : json;

    final summary = QueueSummaryModel.fromJson(summaryJson);

    return DoctorQueueModel(
      items: items,
      summary: summary,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items
          .map((e) => (e as QueuePatientModel).toJson())
          .toList(),
      'summary': (summary as QueueSummaryModel).toJson(),
    };
  }
}
