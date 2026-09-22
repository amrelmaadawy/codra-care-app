import '../../domain/entities/doctor_report_chart_entity.dart';

class DoctorReportChartModel extends DoctorReportChartEntity {
  const DoctorReportChartModel({
    required super.labels,
    required super.earnings,
    required super.revenues,
    required super.patientCounts,
    required super.year,
  });

  factory DoctorReportChartModel.fromJson(Map<String, dynamic> json) {
    final labelsList = (json['labels'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final earningsList = (json['earnings'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [];

    final revenuesList = (json['revenues'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList() ??
        [];

    final patientCountsList = (json['patient_counts'] as List<dynamic>?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [];

    return DoctorReportChartModel(
      labels: labelsList,
      earnings: earningsList,
      revenues: revenuesList,
      patientCounts: patientCountsList,
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
    );
  }
}
