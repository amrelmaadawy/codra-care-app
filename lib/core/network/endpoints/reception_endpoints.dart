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
  static const String queue = '/reception/queue';
  static String queuePresence(int id) => '/reception/queue/$id/presence';
  static String queueVitals(int id) => '/reception/queue/$id/vitals';
  static String queueCallDoctor(int id) => '/reception/queue/$id/call-doctor';
  static String queueComplete(int id) => '/reception/queue/$id/complete';
  static String queueCancel(int id) => '/reception/queue/$id/cancel';
}
