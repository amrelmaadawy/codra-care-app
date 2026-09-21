import '../../domain/entities/patient_list_result_entity.dart';
import 'patient_summary_model.dart';

class PatientListResultModel extends PatientListResultEntity {
  const PatientListResultModel({
    required super.items,
    required super.total,
    required super.currentPage,
    required super.lastPage,
    super.totalPatientsStat,
  });

  factory PatientListResultModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>? ?? [];
    final items = rawData
        .map((p) => PatientSummaryModel.fromJson(p as Map<String, dynamic>))
        .toList();

    final quickStats = json['quick_stats'] as Map<String, dynamic>?;
    final totalPatientsStat = (quickStats?['total_patients'] as num?)?.toInt();

    return PatientListResultModel(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (json['last_page'] as num?)?.toInt() ?? 1,
      totalPatientsStat: totalPatientsStat,
    );
  }
}
