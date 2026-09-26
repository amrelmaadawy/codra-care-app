import 'package:equatable/equatable.dart';
import 'follow_up_summary_entity.dart';
import 'reception_follow_up_entity.dart';

class FollowUpsPageEntity extends Equatable {
  final List<ReceptionFollowUpEntity> items;
  final FollowUpSummaryEntity summary;
  final int currentPage;
  final int lastPage;
  final int total;

  const FollowUpsPageEntity({
    required this.items,
    required this.summary,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
        items,
        summary,
        currentPage,
        lastPage,
        total,
      ];
}
