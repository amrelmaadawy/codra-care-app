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
  static String checkInAppointment(int id) =>
      '/reception/check-in/$id';
  static const String upcomingDays = '/reception/upcoming-days';
  static const String availableSlots = '/reception/available-slots';
  static String doctorQuestions(int doctorId) =>
      '/reception/doctors/$doctorId/questions';
  static const String walkIn = '/reception/walk-in';
}
