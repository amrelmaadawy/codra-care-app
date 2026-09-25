import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/appointment_calendar_day_entity.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/entities/appointment_filters.dart';
import '../../domain/entities/appointments_page_entity.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

final class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

final class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

final class AppointmentsLoaded extends AppointmentsState {
  final AppointmentsPageEntity page;
  final List<AppointmentCalendarDayEntity> calendarDays;
  final String selectedDate;
  final String currentMonth;
  final bool isMonthExpanded;
  final bool isPaginating;
  final int? cancellingId;
  final String? cancelError;
  final String? cancelSuccessMessage;
  final String? refreshWarning;

  const AppointmentsLoaded({
    required this.page,
    required this.calendarDays,
    required this.selectedDate,
    required this.currentMonth,
    this.isMonthExpanded = false,
    this.isPaginating = false,
    this.cancellingId,
    this.cancelError,
    this.cancelSuccessMessage,
    this.refreshWarning,
  });

  List<AppointmentEntity> get items => page.items;
  AppointmentFilters get filters => page.appliedFilters;
  bool get hasMore => page.hasMore;

  AppointmentsLoaded copyWith({
    AppointmentsPageEntity? page,
    List<AppointmentCalendarDayEntity>? calendarDays,
    String? selectedDate,
    String? currentMonth,
    bool? isMonthExpanded,
    bool? isPaginating,
    int? cancellingId,
    bool clearCancelling = false,
    String? cancelError,
    bool clearCancelError = false,
    String? cancelSuccessMessage,
    bool clearCancelSuccess = false,
    String? refreshWarning,
    bool clearWarning = false,
  }) {
    return AppointmentsLoaded(
      page: page ?? this.page,
      calendarDays: calendarDays ?? this.calendarDays,
      selectedDate: selectedDate ?? this.selectedDate,
      currentMonth: currentMonth ?? this.currentMonth,
      isMonthExpanded: isMonthExpanded ?? this.isMonthExpanded,
      isPaginating: isPaginating ?? this.isPaginating,
      cancellingId: clearCancelling
          ? null
          : (cancellingId ?? this.cancellingId),
      cancelError: clearCancelError ? null : (cancelError ?? this.cancelError),
      cancelSuccessMessage: clearCancelSuccess
          ? null
          : (cancelSuccessMessage ?? this.cancelSuccessMessage),
      refreshWarning: clearWarning
          ? null
          : (refreshWarning ?? this.refreshWarning),
    );
  }

  @override
  List<Object?> get props => [
    page,
    calendarDays,
    selectedDate,
    currentMonth,
    isMonthExpanded,
    isPaginating,
    cancellingId,
    cancelError,
    cancelSuccessMessage,
    refreshWarning,
  ];
}

final class AppointmentsError extends AppointmentsState {
  final String message;
  final Failure failure;

  const AppointmentsError({required this.message, required this.failure});

  @override
  List<Object?> get props => [message, failure];
}
