import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_report_chart_entity.dart';
import '../../domain/entities/doctor_report_stats_entity.dart';
import '../../domain/entities/doctor_visit_report_entity.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsLoaded extends ReportsState {
  final DoctorReportStatsEntity stats;
  final DoctorReportChartEntity chart;
  final List<DoctorVisitReportEntity> visits;
  final int currentPage;
  final int lastPage;
  final int totalVisits;
  final int perPage;
  final int selectedMonth;
  final int selectedYear;
  final String? searchQuery;
  final bool isLoadingMore;

  const ReportsLoaded({
    required this.stats,
    required this.chart,
    required this.visits,
    required this.currentPage,
    required this.lastPage,
    required this.totalVisits,
    required this.perPage,
    required this.selectedMonth,
    required this.selectedYear,
    this.searchQuery,
    this.isLoadingMore = false,
  });

  bool get hasMore => currentPage < lastPage;

  ReportsLoaded copyWith({
    DoctorReportStatsEntity? stats,
    DoctorReportChartEntity? chart,
    List<DoctorVisitReportEntity>? visits,
    int? currentPage,
    int? lastPage,
    int? totalVisits,
    int? perPage,
    int? selectedMonth,
    int? selectedYear,
    String? searchQuery,
    bool? isLoadingMore,
  }) {
    return ReportsLoaded(
      stats: stats ?? this.stats,
      chart: chart ?? this.chart,
      visits: visits ?? this.visits,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      totalVisits: totalVisits ?? this.totalVisits,
      perPage: perPage ?? this.perPage,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        stats,
        chart,
        visits,
        currentPage,
        lastPage,
        totalVisits,
        perPage,
        selectedMonth,
        selectedYear,
        searchQuery,
        isLoadingMore,
      ];
}

class ReportsError extends ReportsState {
  final Failure failure;
  final String message;

  const ReportsError({required this.failure, required this.message});

  @override
  List<Object?> get props => [failure, message];
}
