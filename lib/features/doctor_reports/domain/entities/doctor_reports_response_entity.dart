import 'package:equatable/equatable.dart';
import 'doctor_report_chart_entity.dart';
import 'doctor_report_stats_entity.dart';
import 'doctor_visit_report_entity.dart';

class DoctorReportsResponseEntity extends Equatable {
  final DoctorReportStatsEntity stats;
  final DoctorReportChartEntity chart;
  final List<DoctorVisitReportEntity> visits;
  final int currentPage;
  final int lastPage;
  final int totalVisits;
  final int perPage;

  const DoctorReportsResponseEntity({
    required this.stats,
    required this.chart,
    required this.visits,
    required this.currentPage,
    required this.lastPage,
    required this.totalVisits,
    required this.perPage,
  });

  @override
  List<Object?> get props => [
        stats,
        chart,
        visits,
        currentPage,
        lastPage,
        totalVisits,
        perPage,
      ];
}
