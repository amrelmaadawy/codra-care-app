import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/diagnosis_template_entity.dart';

enum DiagnosisTemplateFilterChip {
  all,
  topUsed,
  hasDiagnosis,
  hasComplaint,
  hasNotes,
}

sealed class DiagnosisTemplateListState extends Equatable {
  const DiagnosisTemplateListState();

  @override
  List<Object?> get props => [];
}

class DiagnosisTemplateListInitial extends DiagnosisTemplateListState {
  const DiagnosisTemplateListInitial();
}

class DiagnosisTemplateListLoading extends DiagnosisTemplateListState {
  const DiagnosisTemplateListLoading();
}

class DiagnosisTemplateListLoaded extends DiagnosisTemplateListState {
  final List<DiagnosisTemplateEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final bool isFetchingMore;
  final String? searchQuery;
  final DiagnosisTemplateFilterChip selectedFilter;
  final bool isMutating;

  const DiagnosisTemplateListLoaded({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.hasMore = false,
    this.isFetchingMore = false,
    this.searchQuery,
    this.selectedFilter = DiagnosisTemplateFilterChip.all,
    this.isMutating = false,
  });

  List<DiagnosisTemplateEntity> get filteredItems {
    switch (selectedFilter) {
      case DiagnosisTemplateFilterChip.all:
        return items;
      case DiagnosisTemplateFilterChip.topUsed:
        final sorted = List<DiagnosisTemplateEntity>.from(items);
        sorted.sort((a, b) => b.usageCount.compareTo(a.usageCount));
        return sorted.where((e) => e.usageCount > 0).toList();
      case DiagnosisTemplateFilterChip.hasDiagnosis:
        return items.where((e) => e.hasDiagnosis).toList();
      case DiagnosisTemplateFilterChip.hasComplaint:
        return items.where((e) => e.hasChiefComplaint).toList();
      case DiagnosisTemplateFilterChip.hasNotes:
        return items.where((e) => e.hasNotes).toList();
    }
  }

  DiagnosisTemplateListLoaded copyWith({
    List<DiagnosisTemplateEntity>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
    bool? isFetchingMore,
    String? searchQuery,
    DiagnosisTemplateFilterChip? selectedFilter,
    bool? isMutating,
  }) {
    return DiagnosisTemplateListLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isMutating: isMutating ?? this.isMutating,
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
        selectedFilter,
        isMutating,
      ];
}

class DiagnosisTemplateListEmpty extends DiagnosisTemplateListState {
  final String? searchQuery;
  final DiagnosisTemplateFilterChip selectedFilter;

  const DiagnosisTemplateListEmpty({
    this.searchQuery,
    this.selectedFilter = DiagnosisTemplateFilterChip.all,
  });

  @override
  List<Object?> get props => [searchQuery, selectedFilter];
}

class DiagnosisTemplateListError extends DiagnosisTemplateListState {
  final Failure failure;

  const DiagnosisTemplateListError(this.failure);

  @override
  List<Object?> get props => [failure];
}
