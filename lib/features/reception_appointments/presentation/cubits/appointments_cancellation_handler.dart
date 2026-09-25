import '../../domain/entities/appointments_page_entity.dart';
import '../../domain/usecases/cancel_appointment_use_case.dart';
import 'appointments_state.dart';

class AppointmentsCancellationHandler {
  final CancelAppointmentUseCase _cancelUseCase;

  const AppointmentsCancellationHandler(this._cancelUseCase);

  Future<void> cancel({
    required AppointmentsLoaded currentState,
    required int appointmentId,
    required String reason,
    required void Function(AppointmentsLoaded newState) onStateChanged,
  }) async {
    onStateChanged(currentState.copyWith(
      cancellingId: appointmentId,
      clearCancelError: true,
      clearCancelSuccess: true,
    ));

    final res = await _cancelUseCase(
      appointmentId: appointmentId,
      reason: reason,
    );

    res.fold(
      (f) {
        onStateChanged(currentState.copyWith(
          clearCancelling: true,
          cancelError: f.message,
        ));
      },
      (cancelled) {
        final updated = currentState.items
            .map((i) => i.id == appointmentId ? cancelled : i)
            .toList();
        onStateChanged(currentState.copyWith(
          clearCancelling: true,
          cancelSuccessMessage: 'reception_appointments.cancel_success',
          page: AppointmentsPageEntity(
            items: updated,
            currentPage: currentState.page.currentPage,
            lastPage: currentState.page.lastPage,
            perPage: currentState.page.perPage,
            total: currentState.page.total,
            hasMore: currentState.page.hasMore,
            appliedFilters: currentState.page.appliedFilters,
          ),
        ));
      },
    );
  }
}
