import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_leave_days_summary_entity.dart';

sealed class LeaveDaysState extends Equatable {
  const LeaveDaysState();

  @override
  List<Object?> get props => [];
}

final class LeaveDaysInitial extends LeaveDaysState {
  const LeaveDaysInitial();
}

final class LeaveDaysLoading extends LeaveDaysState {
  const LeaveDaysLoading();
}

final class LeaveDaysLoaded extends LeaveDaysState {
  final DoctorLeaveDaysSummaryEntity summary;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final bool isActionLoading;

  const LeaveDaysLoaded({
    required this.summary,
    required this.focusedDay,
    this.selectedDay,
    this.isActionLoading = false,
  });

  LeaveDaysLoaded copyWith({
    DoctorLeaveDaysSummaryEntity? summary,
    DateTime? focusedDay,
    DateTime? selectedDay,
    bool? isActionLoading,
    bool clearSelectedDay = false,
  }) {
    return LeaveDaysLoaded(
      summary: summary ?? this.summary,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: clearSelectedDay ? null : (selectedDay ?? this.selectedDay),
      isActionLoading: isActionLoading ?? this.isActionLoading,
    );
  }

  @override
  List<Object?> get props => [
        summary,
        focusedDay,
        selectedDay,
        isActionLoading,
      ];
}

final class LeaveDaysError extends LeaveDaysState {
  final Failure failure;

  const LeaveDaysError(this.failure);

  @override
  List<Object?> get props => [failure];
}
