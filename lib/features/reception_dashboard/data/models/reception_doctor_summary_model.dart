import '../../domain/entities/reception_doctor_summary_entity.dart';

class ReceptionDoctorSummaryModel extends ReceptionDoctorSummaryEntity {
  const ReceptionDoctorSummaryModel({
    required super.id,
    required super.name,
    required super.todayCount,
  });

  factory ReceptionDoctorSummaryModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw const FormatException(
        'Missing required field: id in doctor summary',
      );
    }

    final countRaw = json['today_count'] ?? json['todayCount'];

    return ReceptionDoctorSummaryModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?) ?? '',
      todayCount: (countRaw as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'today_count': todayCount};
  }
}
