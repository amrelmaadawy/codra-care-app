import '../../domain/entities/reception_queue_entity.dart';
import 'queue_doctor_model.dart';
import 'queue_summary_model.dart';
import 'reception_queue_item_model.dart';

class ReceptionQueueModel extends ReceptionQueueEntity {
  const ReceptionQueueModel({
    super.items,
    super.summary,
    super.doctors,
    super.total,
    super.page,
    super.perPage,
    super.lastPage,
  });

  factory ReceptionQueueModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    List<ReceptionQueueItemModel> items = [];
    if (rawData is List) {
      items = rawData
          .map((item) => ReceptionQueueItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final rawDoctors = json['doctors'];
    List<QueueDoctorModel> doctors = [];
    if (rawDoctors is List) {
      doctors = rawDoctors
          .map((d) => QueueDoctorModel.fromJson(d as Map<String, dynamic>))
          .toList();
    }

    final summary = QueueSummaryModel.fromJson(json['summary'] as Map<String, dynamic>?);
    final meta = json['meta'] as Map<String, dynamic>?;

    final total = (meta?['total'] ?? json['total'] as num?)?.toInt() ?? items.length;
    final page = (meta?['current_page'] ?? json['page'] as num?)?.toInt() ?? 1;
    final perPage = (meta?['per_page'] ?? json['per_page'] as num?)?.toInt() ?? 25;
    final lastPage = (meta?['last_page'] ?? json['last_page'] as num?)?.toInt() ?? 1;

    return ReceptionQueueModel(
      items: items,
      summary: summary,
      doctors: doctors,
      total: total,
      page: page,
      perPage: perPage,
      lastPage: lastPage,
    );
  }
}
