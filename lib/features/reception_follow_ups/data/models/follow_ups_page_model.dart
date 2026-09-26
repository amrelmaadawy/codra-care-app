import '../../domain/entities/follow_ups_page_entity.dart';
import 'follow_up_summary_model.dart';
import 'reception_follow_up_model.dart';

class FollowUpsPageModel extends FollowUpsPageEntity {
  const FollowUpsPageModel({
    required super.items,
    required super.summary,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory FollowUpsPageModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((item) =>
            ReceptionFollowUpModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final summaryMap = json['summary'] as Map<String, dynamic>? ?? {};
    final summary = FollowUpSummaryModel.fromJson(summaryMap);

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final currentPage = meta['current_page'] as int? ?? 1;
    final lastPage = meta['last_page'] as int? ?? 1;
    final total = meta['total'] as int? ?? items.length;

    return FollowUpsPageModel(
      items: items,
      summary: summary,
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }
}
