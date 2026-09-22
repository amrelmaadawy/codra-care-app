import 'package:equatable/equatable.dart';

class DoctorReportStatsEntity extends Equatable {
  final int filterMonth;
  final int filterYear;
  final String monthName;
  final double monthEarnings;
  final int monthPatients;
  final double monthRevenue;
  final double yearEarnings;
  final int yearPatients;
  final double yearRevenue;
  final String bestMonthName;
  final double bestMonthEarnings;
  final double averageMonthly;
  final String commissionType;
  final double commissionPercentage;
  final double commissionFixedAmount;

  const DoctorReportStatsEntity({
    required this.filterMonth,
    required this.filterYear,
    required this.monthName,
    required this.monthEarnings,
    required this.monthPatients,
    required this.monthRevenue,
    required this.yearEarnings,
    required this.yearPatients,
    required this.yearRevenue,
    required this.bestMonthName,
    required this.bestMonthEarnings,
    required this.averageMonthly,
    required this.commissionType,
    required this.commissionPercentage,
    required this.commissionFixedAmount,
  });

  @override
  List<Object?> get props => [
        filterMonth,
        filterYear,
        monthName,
        monthEarnings,
        monthPatients,
        monthRevenue,
        yearEarnings,
        yearPatients,
        yearRevenue,
        bestMonthName,
        bestMonthEarnings,
        averageMonthly,
        commissionType,
        commissionPercentage,
        commissionFixedAmount,
      ];
}
