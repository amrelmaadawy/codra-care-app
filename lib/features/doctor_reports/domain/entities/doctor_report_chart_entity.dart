import 'package:equatable/equatable.dart';

class DoctorReportChartEntity extends Equatable {
  final List<String> labels;
  final List<double> earnings;
  final List<double> revenues;
  final List<int> patientCounts;
  final int year;

  const DoctorReportChartEntity({
    required this.labels,
    required this.earnings,
    required this.revenues,
    required this.patientCounts,
    required this.year,
  });

  @override
  List<Object?> get props => [labels, earnings, revenues, patientCounts, year];
}
