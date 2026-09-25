import '../../domain/entities/reception_dashboard_capabilities_entity.dart';

class ReceptionDashboardCapabilitiesModel
    extends ReceptionDashboardCapabilitiesEntity {
  const ReceptionDashboardCapabilitiesModel({
    required super.canViewAppointments,
    required super.canViewQueue,
    required super.canViewFollowUps,
  });

  factory ReceptionDashboardCapabilitiesModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const ReceptionDashboardCapabilitiesModel(
        canViewAppointments: true,
        canViewQueue: true,
        canViewFollowUps: true,
      );
    }

    return ReceptionDashboardCapabilitiesModel(
      canViewAppointments: (json['can_view_appointments'] as bool?) ?? true,
      canViewQueue: (json['can_view_queue'] as bool?) ?? true,
      canViewFollowUps: (json['can_view_follow_ups'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'can_view_appointments': canViewAppointments,
      'can_view_queue': canViewQueue,
      'can_view_follow_ups': canViewFollowUps,
    };
  }
}
