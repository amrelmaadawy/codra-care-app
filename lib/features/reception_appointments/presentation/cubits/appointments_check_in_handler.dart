import '../../domain/usecases/check_in_appointment_use_case.dart';
import 'appointments_state.dart';

class AppointmentsCheckInHandler {
  final CheckInAppointmentUseCase _checkInUseCase;

  const AppointmentsCheckInHandler(this._checkInUseCase);

  Future<void> checkIn({
    required AppointmentsLoaded currentState,
    required int appointmentId,
    String priority = 'normal',
    String? clientRequestId,
    required void Function(AppointmentsLoaded newState) onStateChanged,
  }) async {
    onStateChanged(currentState.copyWith(
      checkingInId: appointmentId,
      clearCheckInError: true,
      clearCheckInSuccess: true,
    ));

    final res = await _checkInUseCase(
      appointmentId: appointmentId,
      priority: priority,
      clientRequestId: clientRequestId,
    );

    res.fold(
      (f) {
        onStateChanged(currentState.copyWith(
          clearCheckingIn: true,
          checkInError: f.message,
        ));
      },
      (result) {
        onStateChanged(currentState.copyWith(
          clearCheckingIn: true,
          checkInSuccessMessage: result.alreadyCheckedIn
              ? 'reception_appointments.already_checked_in_msg'
              : 'reception_appointments.check_in_success_msg',
        ));
      },
    );
  }
}
