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
  static const String followUps = '/reception/follow-ups';
  static String followUpScheduleContext(int visitId) =>
      '/reception/follow-ups/$visitId/schedule-context';
  static String scheduleFollowUp(int visitId) =>
      '/reception/follow-ups/$visitId/schedule';

  // Reception Internal Chat
  static const String internalChats = '/reception/internal-chat/chats';
  static String internalChatDetail(int chatId) =>
      '/reception/internal-chat/chats/$chatId';
  static String internalChatPoll(int chatId) =>
      '/reception/internal-chat/chats/$chatId/poll';
  static String internalChatSend(int chatId) =>
      '/reception/internal-chat/chats/$chatId/send';
  static String internalChatRead(int chatId) =>
      '/reception/internal-chat/chats/$chatId/read';
  static const String internalChatUnreadCount =
      '/reception/internal-chat/unread-count';

  // Reception Payments & Financials
  static String appointmentTransactions(int id) =>
      '/reception/appointments/$id/transactions';
  static String appointmentServiceOptions(int id) =>
      '/reception/appointments/$id/service-options';
  static String appointmentPayments(int id) =>
      '/reception/appointments/$id/payments';
  static String appointmentRefunds(int id) =>
      '/reception/appointments/$id/refunds';
  static String appointmentDiscounts(int id) =>
      '/reception/appointments/$id/discounts';
  static String appointmentServices(int id) =>
      '/reception/appointments/$id/services';
  static String appointmentVoucherPreview(int id, int voucherId) =>
      '/reception/appointments/$id/voucher/$voucherId/preview';
}
