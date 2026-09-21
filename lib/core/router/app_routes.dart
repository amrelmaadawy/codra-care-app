abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String shell = '/shell';

  // Doctor shell routes
  static const String doctorDashboard = '/shell/dashboard';
  static const String queue = '/shell/queue';
  static const String patients = '/shell/patients';
  static const String prescriptions = '/shell/prescriptions';
  static const String reports = '/shell/reports';
  static const String profile = '/shell/profile';

  // Reception/Admin shell routes
  static const String reception = '/shell/reception';
  static const String appointments = '/shell/appointments';
  static const String financial = '/shell/financial';
  static const String settings = '/shell/settings';
}
