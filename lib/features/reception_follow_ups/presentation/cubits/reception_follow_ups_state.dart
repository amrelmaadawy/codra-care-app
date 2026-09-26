import 'package:equatable/equatable.dart';
import '../../domain/entities/follow_up_summary_entity.dart';
import '../../domain/entities/get_follow_ups_params.dart';
import '../../domain/entities/reception_follow_up_entity.dart';

enum FollowUpsStatus { initial, loading, success, error }

class ReceptionFollowUpsState extends Equatable {
  final FollowUpsStatus status;
  final List<ReceptionFollowUpEntity> items;
  final FollowUpSummaryEntity summary;
  final GetFollowUpsParams params;
  final bool isSilentRefreshing;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final int requestGeneration;
  final Set<int> expandedItemIds;

  const ReceptionFollowUpsState({
    this.status = FollowUpsStatus.initial,
    this.items = const [],
    this.summary = const FollowUpSummaryEntity.empty(),
    this.params = const GetFollowUpsParams(),
    this.isSilentRefreshing = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
    this.requestGeneration = 0,
    this.expandedItemIds = const {},
  });

  bool get isLoading => status == FollowUpsStatus.loading;
  bool get isSuccess => status == FollowUpsStatus.success;
  bool get isError => status == FollowUpsStatus.error;
  bool get isEmpty => isSuccess && items.isEmpty;

  ReceptionFollowUpsState copyWith({
    FollowUpsStatus? status,
    List<ReceptionFollowUpEntity>? items,
    FollowUpSummaryEntity? summary,
    GetFollowUpsParams? params,
    bool? isSilentRefreshing,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
    int? requestGeneration,
    Set<int>? expandedItemIds,
  }) {
    return ReceptionFollowUpsState(
      status: status ?? this.status,
      items: items ?? this.items,
      summary: summary ?? this.summary,
      params: params ?? this.params,
      isSilentRefreshing: isSilentRefreshing ?? this.isSilentRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      requestGeneration: requestGeneration ?? this.requestGeneration,
      expandedItemIds: expandedItemIds ?? this.expandedItemIds,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        summary,
        params,
        isSilentRefreshing,
        isLoadingMore,
        hasMore,
        errorMessage,
        requestGeneration,
        expandedItemIds,
      ];
}
