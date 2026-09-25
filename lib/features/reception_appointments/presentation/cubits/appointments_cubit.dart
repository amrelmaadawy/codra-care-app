import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/appointment_enums.dart';
import '../../domain/entities/appointment_filters.dart';
import '../../domain/usecases/cancel_appointment_use_case.dart';
import '../../domain/usecases/check_in_appointment_use_case.dart';
import '../../domain/usecases/get_appointments_use_case.dart';
import '../../domain/usecases/get_calendar_events_use_case.dart';
import 'appointments_calendar_handler.dart';
import 'appointments_cancellation_handler.dart';
import 'appointments_check_in_handler.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final AppointmentsCancellationHandler _cancellationHandler;
  final AppointmentsCheckInHandler _checkInHandler;
  final AppointmentsCalendarHandler _calendarHandler;

  AppointmentsCubit({
    required GetAppointmentsUseCase getAppointmentsUseCase,
    required GetCalendarEventsUseCase getCalendarEventsUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
    required CheckInAppointmentUseCase checkInAppointmentUseCase,
  }) : _getAppointmentsUseCase = getAppointmentsUseCase,
       _cancellationHandler = AppointmentsCancellationHandler(
         cancelAppointmentUseCase,
       ),
       _checkInHandler = AppointmentsCheckInHandler(
         checkInAppointmentUseCase,
       ),
       _calendarHandler = AppointmentsCalendarHandler(
         getAppointmentsUseCase: getAppointmentsUseCase,
         getCalendarEventsUseCase: getCalendarEventsUseCase,
       ),
       super(const AppointmentsInitial());

  Future<void> loadInitial({String? initialDate}) => _calendarHandler
      .loadInitial(initialDate: initialDate, onStateChanged: emit);

  Future<void> selectDate(String date) async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _calendarHandler.selectDate(
        currentState: curr,
        date: date,
        onStateChanged: emit,
      );
    }
  }

  Future<void> changeMonth(String month) async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _calendarHandler.changeMonth(
        currentState: curr,
        month: month,
        onStateChanged: emit,
      );
    }
  }

  void toggleMonthExpanded() {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      emit(curr.copyWith(isMonthExpanded: !curr.isMonthExpanded));
    }
  }

  Future<void> setDoctorFilter(int? doctorId) => _updateFilters(
    (f) => f.copyWith(doctorId: doctorId, clearDoctorId: doctorId == null),
  );

  Future<void> setStatusFilter(AppointmentStatus? status) => _updateFilters(
    (f) => f.copyWith(status: status, clearStatus: status == null),
  );

  Future<void> clearFilters() async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _calendarHandler.reloadWithFilters(
        currentState: curr,
        filters: AppointmentFilters(date: curr.selectedDate),
        onStateChanged: emit,
      );
    }
  }

  Future<void> _updateFilters(
    AppointmentFilters Function(AppointmentFilters) fn,
  ) async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _calendarHandler.reloadWithFilters(
        currentState: curr,
        filters: fn(curr.filters),
        onStateChanged: emit,
      );
    }
  }

  Future<void> loadMore() async {
    final curr = state;
    if (curr is! AppointmentsLoaded || !curr.hasMore || curr.isPaginating) {
      return;
    }
    emit(curr.copyWith(isPaginating: true));
    final res = await _getAppointmentsUseCase(
      filters: curr.filters,
      page: curr.page.currentPage + 1,
      perPage: curr.page.perPage,
    );
    res.fold(
      (f) =>
          emit(curr.copyWith(isPaginating: false, refreshWarning: f.message)),
      (more) => emit(
        curr.copyWith(
          isPaginating: false,
          page: curr.page.append(more),
          clearWarning: true,
        ),
      ),
    );
  }

  Future<void> cancelAppointment({
    required int appointmentId,
    required String reason,
  }) async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _cancellationHandler.cancel(
        currentState: curr,
        appointmentId: appointmentId,
        reason: reason,
        onStateChanged: emit,
      );
    }
  }

  void setCheckInMode(bool isCheckIn) {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      emit(curr.copyWith(isCheckInMode: isCheckIn));
    }
  }

  Future<void> checkInAppointment({
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
  }) async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _checkInHandler.checkIn(
        currentState: curr,
        appointmentId: appointmentId,
        priority: priority,
        clientRequestId: clientRequestId,
        onStateChanged: emit,
      );
      await refresh();
    }
  }

  Future<void> refresh() async {
    final curr = state;
    if (curr is AppointmentsLoaded) {
      await _calendarHandler.reloadWithFilters(
        currentState: curr,
        filters: curr.filters,
        onStateChanged: emit,
      );
    } else {
      await loadInitial();
    }
  }
}
