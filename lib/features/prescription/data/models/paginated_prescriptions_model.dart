import '../../domain/entities/paginated_prescriptions_entity.dart';
import 'prescription_model.dart';

class PaginatedPrescriptionsModel extends PaginatedPrescriptionsEntity {
  const PaginatedPrescriptionsModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory PaginatedPrescriptionsModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    final items = rawList
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionModel.fromJson)
        .toList();

    return PaginatedPrescriptionsModel(
      items: items,
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      total: json['total'] as int? ?? items.length,
    );
  }
}
