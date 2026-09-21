import 'package:equatable/equatable.dart';

class DoctorDashboardEntity extends Equatable {
  final int doctorId;
  final String doctorName;
  final String? specialization;
  final String? title;
  final int todayQueueCount;
  final int waitingCount;
  final int withDoctorCount;
  final int completedToday;
  final int todayAppointmentsCount;
  final int pendingFollowUps;
  final double? revenueMonth;
  final int patientsToday;
  final int patientsMonth;
  final int patientsTotal;

  const DoctorDashboardEntity({
    required this.doctorId,
    required this.doctorName,
    this.specialization,
    this.title,
    required this.todayQueueCount,
    required this.waitingCount,
    required this.withDoctorCount,
    required this.completedToday,
    required this.todayAppointmentsCount,
    required this.pendingFollowUps,
    this.revenueMonth,
    required this.patientsToday,
    required this.patientsMonth,
    required this.patientsTotal,
  });

  @override
  List<Object?> get props => [
    doctorId,
    doctorName,
    specialization,
    title,
    todayQueueCount,
    waitingCount,
    withDoctorCount,
    completedToday,
    todayAppointmentsCount,
    pendingFollowUps,
    revenueMonth,
    patientsToday,
    patientsMonth,
    patientsTotal,
  ];
}
