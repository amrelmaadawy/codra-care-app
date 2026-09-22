import '../../domain/entities/doctor_reports_response_entity.dart';
import 'doctor_report_chart_model.dart';
import 'doctor_report_stats_model.dart';
import 'doctor_visit_report_model.dart';

class DoctorReportsResponseModel extends DoctorReportsResponseEntity {
  const DoctorReportsResponseModel({
    required super.stats,
    required super.chart,
    required super.visits,
    required super.currentPage,
    required super.lastPage,
    required super.totalVisits,
    required super.perPage,
  });

  factory DoctorReportsResponseModel.fromJson(Map<String, dynamic> json) {
    final statsData = json['stats'] is Map<String, dynamic>
        ? json['stats'] as Map<String, dynamic>
        : <String, dynamic>{};

    final chartData = json['chart'] is Map<String, dynamic>
        ? json['chart'] as Map<String, dynamic>
        : <String, dynamic>{};

    final visitsWrapper = json['visits'] is Map<String, dynamic>
        ? json['visits'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawVisits = (visitsWrapper['data'] as List<dynamic>?) ?? [];
    final visitsList = rawVisits
        .whereType<Map<String, dynamic>>()
        .map(DoctorVisitReportModel.fromJson)
        .toList();

    return DoctorReportsResponseModel(
      stats: DoctorReportStatsModel.fromJson(statsData),
      chart: DoctorReportChartModel.fromJson(chartData),
      visits: visitsList,
      currentPage: (visitsWrapper['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (visitsWrapper['last_page'] as num?)?.toInt() ?? 1,
      totalVisits: (visitsWrapper['total'] as num?)?.toInt() ?? visitsList.length,
      perPage: (visitsWrapper['per_page'] as num?)?.toInt() ?? 15,
    );
  }
}
