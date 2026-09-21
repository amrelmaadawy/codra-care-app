import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_summary_entity.dart';

sealed class PatientListState extends Equatable {
  const PatientListState();

  @override
  List<Object?> get props => [];
}

class PatientListInitial extends PatientListState {
  const PatientListInitial();
}

class PatientListLoading extends PatientListState {
  const PatientListLoading();
}

class PatientListLoaded extends PatientListState {
  final List<PatientSummaryEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;
  final bool isFetchingMore;
  final String? searchQuery;
  final int? totalPatientsStat;

  const PatientListLoaded({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.hasMore = false,
    this.isFetchingMore = false,
    this.searchQuery,
    this.totalPatientsStat,
  });

  PatientListLoaded copyWith({
    List<PatientSummaryEntity>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
    bool? isFetchingMore,
    String? searchQuery,
    int? totalPatientsStat,
  }) {
    return PatientListLoaded(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      totalPatientsStat: totalPatientsStat ?? this.totalPatientsStat,
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
    totalPatientsStat,
  ];
}

class PatientListEmpty extends PatientListState {
  final String? searchQuery;

  const PatientListEmpty({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class PatientListError extends PatientListState {
  final Failure failure;

  const PatientListError(this.failure);

  @override
  List<Object?> get props => [failure];
}
