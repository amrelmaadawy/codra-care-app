abstract final class ReceptionEndpoints {
  static const String dashboard = '/reception/dashboard';
  static const String appointments = '/reception/appointments';
  static const String appointmentsCalendar =
      '/reception/appointments/calendar-events';
  static const String appointmentsFormContext =
      '/reception/appointments/form-context';
  static const String appointmentsPatientSearch =
      '/reception/appointments/patients/search';
  static String cancelAppointment(int id) =>
      '/reception/appointments/$id/cancel';
}
