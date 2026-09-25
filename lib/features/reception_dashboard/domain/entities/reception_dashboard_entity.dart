import 'package:equatable/equatable.dart';
import 'appointment_today_stats_entity.dart';
import 'reception_dashboard_capabilities_entity.dart';
import 'reception_doctor_summary_entity.dart';
import 'reception_queue_item_entity.dart';

class ReceptionDashboardEntity extends Equatable {
  final AppointmentTodayStatsEntity appointmentsToday;
  final int totalPatientsToday;
  final List<ReceptionQueueItemEntity> activeQueue;
  final int activeWaitingCount;
  final int pendingFollowUpsCount;
  final List<ReceptionDoctorSummaryEntity> doctors;
  final int? selectedDoctorId;
  final DateTime? generatedAt;
  final ReceptionDashboardCapabilitiesEntity capabilities;

  const ReceptionDashboardEntity({
    required this.appointmentsToday,
    required this.totalPatientsToday,
    required this.activeQueue,
    required this.activeWaitingCount,
    required this.pendingFollowUpsCount,
    required this.doctors,
    this.selectedDoctorId,
    this.generatedAt,
    required this.capabilities,
  });

  ReceptionDashboardEntity copyWith({
    AppointmentTodayStatsEntity? appointmentsToday,
    int? totalPatientsToday,
    List<ReceptionQueueItemEntity>? activeQueue,
    int? activeWaitingCount,
    int? pendingFollowUpsCount,
    List<ReceptionDoctorSummaryEntity>? doctors,
    int? Function()? selectedDoctorId,
    DateTime? generatedAt,
    ReceptionDashboardCapabilitiesEntity? capabilities,
  }) {
    return ReceptionDashboardEntity(
      appointmentsToday: appointmentsToday ?? this.appointmentsToday,
      totalPatientsToday: totalPatientsToday ?? this.totalPatientsToday,
      activeQueue: activeQueue ?? this.activeQueue,
      activeWaitingCount: activeWaitingCount ?? this.activeWaitingCount,
      pendingFollowUpsCount:
          pendingFollowUpsCount ?? this.pendingFollowUpsCount,
      doctors: doctors ?? this.doctors,
      selectedDoctorId: selectedDoctorId != null
          ? selectedDoctorId()
          : this.selectedDoctorId,
      generatedAt: generatedAt ?? this.generatedAt,
      capabilities: capabilities ?? this.capabilities,
    );
  }

  @override
  List<Object?> get props => [
    appointmentsToday,
    totalPatientsToday,
    activeQueue,
    activeWaitingCount,
    pendingFollowUpsCount,
    doctors,
    selectedDoctorId,
    generatedAt,
    capabilities,
  ];
}
