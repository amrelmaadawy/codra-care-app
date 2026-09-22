import 'package:get_it/get_it.dart';
import '../../features/auth/auth_di.dart';
import '../../features/diagnosis_templates/diagnosis_templates_di.dart';
import '../../features/doctor_dashboard/doctor_dashboard_di.dart';
import '../../features/doctor_leave_days/doctor_leave_days_di.dart';
import '../../features/doctor_patients/doctor_patients_di.dart';
import '../../features/doctor_questions/doctor_questions_di.dart';
import '../../features/doctor_queue/doctor_queue_di.dart';
import '../../features/doctor_reports/doctor_reports_di.dart';
import '../../features/examination/examination_di.dart';
import '../../features/prescription/prescription_di.dart';
import '../../features/shell/shell_di.dart';
import '../network/api_client.dart';
import 'permission_service.dart';

Future<void> setupDi() async {
  final sl = GetIt.instance;

  // Core singletons
  sl.registerLazySingleton<ApiClient>(() => ApiClient.instance..initialize());
  sl.registerLazySingleton<PermissionService>(() => PermissionService());

  // Feature DI modules
  setupAuthDi();
  setupShellDi();
  setupDoctorDashboardDi();
  setupDoctorQueueDi();
  setupExaminationDi();
  setupPrescriptionDi();
  setupDoctorPatientsDi();
  setupDiagnosisTemplatesDi();
  setupDoctorQuestionsDi();
  setupDoctorLeaveDaysDi();
  setupDoctorReportsDi();
}

