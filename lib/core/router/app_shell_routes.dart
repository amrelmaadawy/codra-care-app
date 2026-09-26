import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../features/diagnosis_templates/presentation/cubit/diagnosis_template_list_cubit.dart';
import '../../features/diagnosis_templates/presentation/screens/diagnosis_templates_screen.dart';
import '../../features/doctor_dashboard/presentation/screens/doctor_dashboard_screen.dart';
import '../../features/doctor_leave_days/presentation/cubit/leave_days_cubit.dart';
import '../../features/doctor_leave_days/presentation/screens/doctor_leave_days_screen.dart';
import '../../features/doctor_patients/presentation/cubit/patient_list_cubit.dart';
import '../../features/doctor_patients/presentation/screens/doctor_patient_list_screen.dart';
import '../../features/doctor_questions/presentation/cubit/doctor_questions_cubit.dart';
import '../../features/doctor_questions/presentation/screens/doctor_questions_screen.dart';
import '../../features/doctor_queue/presentation/screens/doctor_queue_screen.dart';
import '../../features/doctor_reports/presentation/cubit/reports_cubit.dart';
import '../../features/doctor_reports/presentation/screens/doctor_reports_screen.dart';
import '../../features/prescription/presentation/cubit/prescription_list_cubit.dart';
import '../../features/prescription/presentation/screens/prescriptions_list_screen.dart';
import '../../features/profile/presentation/cubits/profile_cubit.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/reception_appointments/presentation/screens/appointments_screen.dart';
import '../../features/reception_dashboard/presentation/screens/reception_dashboard_screen.dart';
import '../../features/reception_queue/presentation/screens/reception_queue_screen.dart';
import '../../features/shell/presentation/screens/placeholder_shell_content.dart';
import '../constants/app_icons.dart';
import '../di/permission_service.dart';
import 'app_routes.dart';

List<RouteBase> buildAppShellRoutes(PermissionService permissionService) {
  return [
    GoRoute(
      path: AppRoutes.shell,
      redirect: (context, state) => permissionService.isDoctor
          ? AppRoutes.doctorDashboard
          : AppRoutes.reception,
    ),
    GoRoute(
      path: AppRoutes.doctorDashboard,
      builder: (context, state) => const DoctorDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.queue,
      builder: (context, state) => const DoctorQueueScreen(),
    ),
    GoRoute(
      path: AppRoutes.patients,
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<PatientListCubit>(),
        child: const DoctorPatientListScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.prescriptions,
      builder: (context, state) {
        if (!permissionService.isDoctor) {
          return const PlaceholderShellContent(
            titleKey: 'shell.prescriptions',
            icon: AppIcons.prescriptions,
          );
        }
        return BlocProvider(
          create: (_) => GetIt.I<PrescriptionListCubit>(),
          child: const PrescriptionsListScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) {
        if (!permissionService.isDoctor) {
          return const PlaceholderShellContent(
            titleKey: 'shell.reports',
            icon: AppIcons.reports,
          );
        }
        return BlocProvider(
          create: (_) => GetIt.I<ReportsCubit>()..loadReports(),
          child: const DoctorReportsScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.doctorLeaveDays,
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<LeaveDaysCubit>(),
        child: const DoctorLeaveDaysScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.diagnosisTemplates,
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<DiagnosisTemplateListCubit>(),
        child: const DiagnosisTemplatesScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.doctorQuestions,
      builder: (context, state) => BlocProvider(
        create: (_) => GetIt.I<DoctorQuestionsCubit>(),
        child: const DoctorQuestionsScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        if (!permissionService.isDoctor) {
          return const StaffProfileScreen();
        }
        return BlocProvider(
          create: (_) => GetIt.I<ProfileCubit>(),
          child: const DoctorProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.reception,
      redirect: (context, state) {
        if (permissionService.isDoctor &&
            !permissionService.canAccessReceptionDashboard) {
          return AppRoutes.doctorDashboard;
        }
        return null;
      },
      builder: (_, _) => const ReceptionDashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.receptionQueue,
      builder: (_, _) => const ReceptionQueueScreen(),
    ),
    GoRoute(
      path: AppRoutes.appointments,
      builder: (_, state) => AppointmentsScreen(
        initialDate: state.uri.queryParameters['date'],
        isCheckInMode: state.uri.queryParameters['mode'] == 'check_in',
      ),
    ),
    GoRoute(
      path: AppRoutes.financial,
      builder: (_, _) => const PlaceholderShellContent(
        titleKey: 'shell.financial',
        icon: AppIcons.financial,
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (_, _) => const PlaceholderShellContent(
        titleKey: 'shell.settings',
        icon: AppIcons.settings,
      ),
    ),
  ];
}
