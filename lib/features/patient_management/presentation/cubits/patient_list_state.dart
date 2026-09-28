import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_list_entity.dart';
import '../../domain/entities/patient_list_query.dart';

sealed class PatientListState extends Equatable {
  const PatientListState();

  @override
  List<Object?> get props => [];
}

class PatientListInitial extends PatientListState {
  const PatientListInitial();
}

class PatientListLoading extends PatientListState {
  final PatientListQuery query;
  final bool isRefresh;

  const PatientListLoading({required this.query, this.isRefresh = false});

  @override
  List<Object?> get props => [query, isRefresh];
}

class PatientListSuccess extends PatientListState {
  final List<PatientListEntity> items;
  final PatientListQuery query;
  final bool hasMore;
  final int total;
  final bool isPaginating;
  final String? paginationError;

  const PatientListSuccess({
    required this.items,
    required this.query,
    required this.hasMore,
    required this.total,
    this.isPaginating = false,
    this.paginationError,
  });

  PatientListSuccess copyWith({
    List<PatientListEntity>? items,
    PatientListQuery? query,
    bool? hasMore,
    int? total,
    bool? isPaginating,
    String? paginationError,
    bool clearPaginationError = false,
  }) {
    return PatientListSuccess(
      items: items ?? this.items,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      total: total ?? this.total,
      isPaginating: isPaginating ?? this.isPaginating,
      paginationError: clearPaginationError
          ? null
          : (paginationError ?? this.paginationError),
    );
  }

  @override
  List<Object?> get props => [
    items,
    query,
    hasMore,
    total,
    isPaginating,
    paginationError,
  ];
}

class PatientListEmpty extends PatientListState {
  final PatientListQuery query;
  final bool isClinicEmpty;

  const PatientListEmpty({required this.query, required this.isClinicEmpty});

  @override
  List<Object?> get props => [query, isClinicEmpty];
}

class PatientListError extends PatientListState {
  final PatientListQuery query;
  final String message;
  final Failure failure;

  const PatientListError({
    required this.query,
    required this.message,
    required this.failure,
  });

  @override
  List<Object?> get props => [query, message, failure];
}
