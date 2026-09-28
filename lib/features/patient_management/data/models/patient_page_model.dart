import '../../domain/entities/patient_page_entity.dart';
import 'patient_list_model.dart';

class PatientPageModel extends PatientPageEntity {
  const PatientPageModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.hasMore,
  });

  factory PatientPageModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final rawItems = data['items'] as List<dynamic>? ?? [];
    final meta = data['meta'] as Map<String, dynamic>? ?? {};

    final items = rawItems
        .map((item) => PatientListModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    final currentPage = (meta['current_page'] as num?)?.toInt() ?? 1;
    final lastPage = (meta['last_page'] as num?)?.toInt() ?? 1;
    final perPage = (meta['per_page'] as num?)?.toInt() ?? 20;
    final total = (meta['total'] as num?)?.toInt() ?? items.length;
    final hasMore = (meta['has_more'] as bool?) ?? (currentPage < lastPage);

    return PatientPageModel(
      items: items,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
      hasMore: hasMore,
    );
  }
}
