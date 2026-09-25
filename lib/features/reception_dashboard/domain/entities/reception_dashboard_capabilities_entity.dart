import 'package:equatable/equatable.dart';

class ReceptionDashboardCapabilitiesEntity extends Equatable {
  final bool canViewAppointments;
  final bool canViewQueue;
  final bool canViewFollowUps;

  const ReceptionDashboardCapabilitiesEntity({
    required this.canViewAppointments,
    required this.canViewQueue,
    required this.canViewFollowUps,
  });

  const ReceptionDashboardCapabilitiesEntity.all()
    : canViewAppointments = true,
      canViewQueue = true,
      canViewFollowUps = true;

  const ReceptionDashboardCapabilitiesEntity.none()
    : canViewAppointments = false,
      canViewQueue = false,
      canViewFollowUps = false;

  @override
  List<Object?> get props => [
    canViewAppointments,
    canViewQueue,
    canViewFollowUps,
  ];
}
