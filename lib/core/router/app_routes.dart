abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String shell = '/shell';

  // Doctor shell routes
  static const String doctorDashboard = '/shell/dashboard';
  static const String queue = '/shell/queue';
  static const String examination = '/examination/:visitId';
  static String examinationPath(int visitId) => '/examination/$visitId';
  static const String patients = '/shell/patients';
  static const String patientDetail = '/patients/:id';
  static const String prescriptions = '/shell/prescriptions';
  static const String prescriptionNew = '/prescriptions/new';
  static const String prescriptionDetail = '/prescriptions/:id';
  static const String prescriptionEdit = '/prescriptions/:id/edit';
  static const String diagnosisTemplates = '/diagnosis-templates';
  static const String doctorQuestions = '/doctor-questions';
  static const String doctorLeaveDays = '/doctor-leave-days';
  static const String reports = '/shell/reports';
  static const String profile = '/shell/profile';
  static const String doctorChat = '/doctor-chat';
  static const String doctorNotifications = '/doctor-notifications';

  // Reception/Admin shell routes
  static const String reception = '/shell/reception';
  static const String receptionQueue = '/shell/reception/queue';
  static const String appointments = '/shell/appointments';
  static const String appointmentNew = '/appointments/new';
  static const String walkIn = '/reception/walk-in';
  static const String financial = '/shell/financial';
  static const String settings = '/shell/settings';
}
