import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_dashboard_entity.dart';

sealed class DoctorDashboardState extends Equatable {
  const DoctorDashboardState();

  @override
  List<Object?> get props => [];
}

final class DoctorDashboardInitial extends DoctorDashboardState {
  const DoctorDashboardInitial();
}

final class DoctorDashboardLoading extends DoctorDashboardState {
  const DoctorDashboardLoading();
}

final class DoctorDashboardLoaded extends DoctorDashboardState {
  final DoctorDashboardEntity data;

  const DoctorDashboardLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

final class DoctorDashboardError extends DoctorDashboardState {
  final Failure failure;

  const DoctorDashboardError(this.failure);

  @override
  List<Object?> get props => [failure];
}
