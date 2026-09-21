import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prescription_entity.dart';

sealed class PrescriptionListState extends Equatable {
  const PrescriptionListState();

  @override
  List<Object?> get props => [];
}

class PrescriptionListInitial extends PrescriptionListState {
  const PrescriptionListInitial();
}

class PrescriptionListLoading extends PrescriptionListState {
  const PrescriptionListLoading();
}

class PrescriptionListLoaded extends PrescriptionListState {
  final List<PrescriptionEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final bool isFetchingMore;
  final String? searchQuery;
  final bool? filterPrinted;

  const PrescriptionListLoaded({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.hasMore = false,
    this.isFetchingMore = false,
    this.searchQuery,
    this.filterPrinted,
  });

  PrescriptionListLoaded copyWith({
    List<PrescriptionEntity>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
    bool? isFetchingMore,
    String? searchQuery,
    bool? filterPrinted,
    bool clearFilterPrinted = false,
  }) {
    return PrescriptionListLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      filterPrinted: clearFilterPrinted
          ? null
          : (filterPrinted ?? this.filterPrinted),
    );
  }

  @override
  List<Object?> get props => [
        items,
        currentPage,
        lastPage,
        total,
        hasMore,
        isFetchingMore,
        searchQuery,
        filterPrinted,
      ];
}

class PrescriptionListEmpty extends PrescriptionListState {
  final String? searchQuery;
  final bool? filterPrinted;

  const PrescriptionListEmpty({
    this.searchQuery,
    this.filterPrinted,
  });

  @override
  List<Object?> get props => [searchQuery, filterPrinted];
}

class PrescriptionListError extends PrescriptionListState {
  final Failure failure;

  const PrescriptionListError(this.failure);

  @override
  List<Object?> get props => [failure];
}
