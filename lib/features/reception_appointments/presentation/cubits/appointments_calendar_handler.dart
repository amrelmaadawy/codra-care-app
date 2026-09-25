import '../../domain/entities/appointment_filters.dart';
import '../../domain/usecases/get_appointments_use_case.dart';
import '../../domain/usecases/get_calendar_events_use_case.dart';
import 'appointment_date_utils.dart';
import 'appointments_state.dart';

class AppointmentsCalendarHandler {
  final GetAppointmentsUseCase getAppointmentsUseCase;
  final GetCalendarEventsUseCase getCalendarEventsUseCase;

  const AppointmentsCalendarHandler({
    required this.getAppointmentsUseCase,
    required this.getCalendarEventsUseCase,
  });

  Future<void> loadInitial({
    String? initialDate,
    required void Function(AppointmentsState) onStateChanged,
  }) async {
    onStateChanged(const AppointmentsLoading());
    final date = initialDate ?? AppointmentDateUtils.formatDate(DateTime.now());
    final dt = DateTime.tryParse(date) ?? DateTime.now();
    final month = AppointmentDateUtils.formatMonth(dt);

    final apptsRes = await getAppointmentsUseCase(
      filters: AppointmentFilters(date: date),
    );
    final calRes = await getCalendarEventsUseCase(month: month);

    apptsRes.fold(
      (f) => onStateChanged(AppointmentsError(message: f.message, failure: f)),
      (page) => onStateChanged(
        AppointmentsLoaded(
          page: page,
          calendarDays: calRes.getOrElse(() => const []),
          selectedDate: date,
          currentMonth: month,
        ),
      ),
    );
  }

  Future<void> selectDate({
    required AppointmentsLoaded currentState,
    required String date,
    required void Function(AppointmentsState) onStateChanged,
  }) async {
    if (currentState.selectedDate == date) return;
    final newFilters = currentState.filters.copyWith(date: date);
    final dt = DateTime.tryParse(date) ?? DateTime.now();
    final month = AppointmentDateUtils.formatMonth(dt);
    final needsNewMonth = month != currentState.currentMonth;

    final apptsRes = await getAppointmentsUseCase(filters: newFilters);
    apptsRes.fold(
      (f) => onStateChanged(currentState.copyWith(refreshWarning: f.message)),
      (newPage) async {
        final calRes = needsNewMonth
            ? await getCalendarEventsUseCase(
                month: month,
                doctorId: newFilters.doctorId,
                status: newFilters.status,
              )
            : null;
        onStateChanged(
          currentState.copyWith(
            page: newPage,
            selectedDate: date,
            currentMonth: month,
            calendarDays:
                calRes?.getOrElse(() => currentState.calendarDays) ??
                currentState.calendarDays,
            clearWarning: true,
          ),
        );
      },
    );
  }

  Future<void> changeMonth({
    required AppointmentsLoaded currentState,
    required String month,
    required void Function(AppointmentsState) onStateChanged,
  }) async {
    if (currentState.currentMonth == month) return;
    final calRes = await getCalendarEventsUseCase(
      month: month,
      doctorId: currentState.filters.doctorId,
      status: currentState.filters.status,
    );
    calRes.fold(
      (f) => onStateChanged(currentState.copyWith(refreshWarning: f.message)),
      (days) => onStateChanged(
        currentState.copyWith(
          currentMonth: month,
          calendarDays: days,
          clearWarning: true,
        ),
      ),
    );
  }

  Future<void> reloadWithFilters({
    required AppointmentsLoaded currentState,
    required AppointmentFilters filters,
    required void Function(AppointmentsState) onStateChanged,
  }) async {
    final apptsRes = await getAppointmentsUseCase(filters: filters);
    final calRes = await getCalendarEventsUseCase(
      month: currentState.currentMonth,
      doctorId: filters.doctorId,
      status: filters.status,
    );
    apptsRes.fold(
      (f) => onStateChanged(currentState.copyWith(refreshWarning: f.message)),
      (p) => onStateChanged(
        currentState.copyWith(
          page: p,
          calendarDays: calRes.getOrElse(() => currentState.calendarDays),
          clearWarning: true,
        ),
      ),
    );
  }
}
