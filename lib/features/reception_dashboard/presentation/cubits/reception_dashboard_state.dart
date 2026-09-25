import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reception_dashboard_entity.dart';

sealed class ReceptionDashboardState extends Equatable {
  const ReceptionDashboardState();

  @override
  List<Object?> get props => [];
}

final class ReceptionDashboardInitial extends ReceptionDashboardState {
  const ReceptionDashboardInitial();
}

final class ReceptionDashboardLoading extends ReceptionDashboardState {
  const ReceptionDashboardLoading();
}

final class ReceptionDashboardLoaded extends ReceptionDashboardState {
  final ReceptionDashboardEntity data;
  final int? selectedDoctorId;
  final bool isQueueRefreshing;
  final String? refreshWarning;

  const ReceptionDashboardLoaded({
    required this.data,
    this.selectedDoctorId,
    this.isQueueRefreshing = false,
    this.refreshWarning,
  });

  ReceptionDashboardLoaded copyWith({
    ReceptionDashboardEntity? data,
    int? selectedDoctorId,
    bool? isQueueRefreshing,
    String? refreshWarning,
    bool clearWarning = false,
    bool clearSelectedDoctor = false,
  }) {
    return ReceptionDashboardLoaded(
      data: data ?? this.data,
      selectedDoctorId: clearSelectedDoctor
          ? null
          : (selectedDoctorId ?? this.selectedDoctorId),
      isQueueRefreshing: isQueueRefreshing ?? this.isQueueRefreshing,
      refreshWarning: clearWarning
          ? null
          : (refreshWarning ?? this.refreshWarning),
    );
  }

  @override
  List<Object?> get props => [
    data,
    selectedDoctorId,
    isQueueRefreshing,
    refreshWarning,
  ];
}

final class ReceptionDashboardError extends ReceptionDashboardState {
  final Failure failure;
  String get message => failure.message;

  const ReceptionDashboardError(this.failure);

  @override
  List<Object?> get props => [failure];
}
