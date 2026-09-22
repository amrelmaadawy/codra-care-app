import '../../domain/entities/paginated_diagnosis_templates_entity.dart';
import 'diagnosis_template_model.dart';

class PaginatedDiagnosisTemplatesModel
    extends PaginatedDiagnosisTemplatesEntity {
  const PaginatedDiagnosisTemplatesModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory PaginatedDiagnosisTemplatesModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map(DiagnosisTemplateModel.fromJson)
        .toList();

    return PaginatedDiagnosisTemplatesModel(
      items: items,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      total: json['total'] as int? ?? items.length,
    );
  }
}
