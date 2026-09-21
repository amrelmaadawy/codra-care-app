import '../../domain/entities/doctor_dashboard_entity.dart';

class DoctorDashboardModel extends DoctorDashboardEntity {
  const DoctorDashboardModel({
    required super.doctorId,
    required super.doctorName,
    super.specialization,
    super.title,
    required super.todayQueueCount,
    required super.waitingCount,
    required super.withDoctorCount,
    required super.completedToday,
    required super.todayAppointmentsCount,
    required super.pendingFollowUps,
    super.revenueMonth,
    required super.patientsToday,
    required super.patientsMonth,
    required super.patientsTotal,
  });

  factory DoctorDashboardModel.fromJson(Map<String, dynamic> json) {
    return DoctorDashboardModel(
      doctorId: (json['doctor_id'] as num?)?.toInt() ?? 0,
      doctorName: (json['doctor_name'] as String?) ?? '',
      specialization: json['specialization'] as String?,
      title: json['title'] as String?,
      todayQueueCount: (json['today_queue_count'] as num?)?.toInt() ?? 0,
      waitingCount: (json['waiting_count'] as num?)?.toInt() ?? 0,
      withDoctorCount: (json['with_doctor_count'] as num?)?.toInt() ?? 0,
      completedToday: (json['completed_today'] as num?)?.toInt() ?? 0,
      todayAppointmentsCount: (json['today_appointments_count'] as num?)?.toInt() ?? 0,
      pendingFollowUps: (json['pending_follow_ups'] as num?)?.toInt() ?? 0,
      revenueMonth: (json['revenue_month'] as num?)?.toDouble(),
      patientsToday: (json['patients_today'] as num?)?.toInt() ?? 0,
      patientsMonth: (json['patients_month'] as num?)?.toInt() ?? 0,
      patientsTotal: (json['patients_total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'specialization': specialization,
      'title': title,
      'today_queue_count': todayQueueCount,
      'waiting_count': waitingCount,
      'with_doctor_count': withDoctorCount,
      'completed_today': completedToday,
      'today_appointments_count': todayAppointmentsCount,
      'pending_follow_ups': pendingFollowUps,
      'revenue_month': revenueMonth,
      'patients_today': patientsToday,
      'patients_month': patientsMonth,
      'patients_total': patientsTotal,
    };
  }
}
