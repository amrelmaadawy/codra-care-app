import '../../domain/entities/reception_dashboard_entity.dart';
import 'appointment_today_stats_model.dart';
import 'reception_dashboard_capabilities_model.dart';
import 'reception_doctor_summary_model.dart';
import 'reception_queue_item_model.dart';

class ReceptionDashboardModel extends ReceptionDashboardEntity {
  const ReceptionDashboardModel({
    required super.appointmentsToday,
    required super.totalPatientsToday,
    required super.activeQueue,
    required super.activeWaitingCount,
    required super.pendingFollowUpsCount,
    required super.doctors,
    super.selectedDoctorId,
    super.generatedAt,
    required super.capabilities,
  });

  factory ReceptionDashboardModel.fromJson(Map<String, dynamic> json) {
    final appStatsJson = json['appointments_today'] as Map<String, dynamic>?;
    final queueList = (json['active_queue'] as List<dynamic>?) ?? [];
    final doctorsList = (json['doctors'] as List<dynamic>?) ?? [];
    final capabilitiesJson = json['capabilities'] as Map<String, dynamic>?;
    final genAtRaw = json['generated_at'] as String?;

    return ReceptionDashboardModel(
      appointmentsToday: appStatsJson != null
          ? AppointmentTodayStatsModel.fromJson(appStatsJson)
          : const AppointmentTodayStatsModel.empty(),
      totalPatientsToday: (json['total_patients_today'] as num?)?.toInt() ?? 0,
      activeQueue: queueList
          .map(
            (item) =>
                ReceptionQueueItemModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      activeWaitingCount: (json['active_waiting_count'] as num?)?.toInt() ?? 0,
      pendingFollowUpsCount:
          (json['pending_follow_ups_count'] as num?)?.toInt() ?? 0,
      doctors: doctorsList
          .map(
            (doc) => ReceptionDoctorSummaryModel.fromJson(
              doc as Map<String, dynamic>,
            ),
          )
          .toList(),
      selectedDoctorId: (json['selected_doctor_id'] as num?)?.toInt(),
      generatedAt: genAtRaw != null ? DateTime.tryParse(genAtRaw) : null,
      capabilities: ReceptionDashboardCapabilitiesModel.fromJson(
        capabilitiesJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointments_today': (appointmentsToday as AppointmentTodayStatsModel)
          .toJson(),
      'total_patients_today': totalPatientsToday,
      'active_queue': activeQueue
          .map((item) => (item as ReceptionQueueItemModel).toJson())
          .toList(),
      'active_waiting_count': activeWaitingCount,
      'pending_follow_ups_count': pendingFollowUpsCount,
      'doctors': doctors
          .map((doc) => (doc as ReceptionDoctorSummaryModel).toJson())
          .toList(),
      'selected_doctor_id': selectedDoctorId,
      'generated_at': generatedAt?.toIso8601String(),
      'capabilities': (capabilities as ReceptionDashboardCapabilitiesModel)
          .toJson(),
    };
  }
}
