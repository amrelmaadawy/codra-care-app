import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/auth/presentation/cubits/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/diagnosis_templates/presentation/cubit/diagnosis_template_list_cubit.dart';
import '../../features/diagnosis_templates/presentation/screens/diagnosis_templates_screen.dart';
import '../../features/doctor_chat/presentation/screens/doctor_chat_screen.dart';
import '../../features/doctor_notifications/presentation/screens/doctor_notifications_screen.dart';
import '../../features/doctor_dashboard/presentation/screens/doctor_dashboard_screen.dart';
import '../../features/doctor_leave_days/presentation/cubit/leave_days_cubit.dart';
import '../../features/doctor_leave_days/presentation/screens/doctor_leave_days_screen.dart';
import '../../features/doctor_questions/presentation/cubit/doctor_questions_cubit.dart';
import '../../features/doctor_questions/presentation/screens/doctor_questions_screen.dart';
import '../../features/doctor_patients/presentation/cubit/patient_detail_cubit.dart';
import '../../features/doctor_patients/presentation/cubit/patient_list_cubit.dart';
import '../../features/doctor_patients/presentation/screens/doctor_patient_detail_screen.dart';
import '../../features/doctor_patients/presentation/screens/doctor_patient_list_screen.dart';
import '../../features/doctor_queue/presentation/screens/doctor_queue_screen.dart';
import '../../features/examination/presentation/screens/examination_screen.dart';
import '../../features/prescription/presentation/cubit/prescription_detail_cubit.dart';
import '../../features/prescription/presentation/cubit/prescription_form_cubit.dart';
import '../../features/prescription/presentation/cubit/prescription_list_cubit.dart';
import '../../features/prescription/presentation/screens/prescription_detail_screen.dart';
import '../../features/prescription/presentation/screens/prescription_form_screen.dart';
import '../../features/prescription/presentation/screens/prescriptions_list_screen.dart';
import '../../features/doctor_reports/presentation/cubit/reports_cubit.dart';
import '../../features/doctor_reports/presentation/screens/doctor_reports_screen.dart';
import '../../features/profile/presentation/cubits/profile_cubit.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../../features/shell/presentation/screens/placeholder_shell_content.dart';
import '../constants/app_icons.dart';
import '../di/permission_service.dart';
import '../widgets/app_loading_widget.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

GoRouter createRouter(
  AuthCubit authCubit,
  PermissionService permissionService,
) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (context, state) {
      final authState = authCubit.state;
      final isLoginPage = state.matchedLocation == AppRoutes.login;
      final isSplashPage = state.matchedLocation == AppRoutes.splash;

      if (authState is AuthInitial || authState is AuthLoading) {
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;

      if (!isAuthenticated && !isLoginPage) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isLoginPage || isSplashPage)) {
        return permissionService.isDoctor
            ? AppRoutes.doctorDashboard
            : AppRoutes.reception;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const Scaffold(
          body: AppLoadingWidget(messageKey: 'common.loading'),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.patientDetail,
        builder: (context, state) => BlocProvider(
          create: (_) => GetIt.I<PatientDetailCubit>(),
          child: DoctorPatientDetailScreen(
            patientId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.prescriptionNew,
        builder: (context, state) => BlocProvider(
          create: (_) => GetIt.I<PrescriptionFormCubit>(),
          child: PrescriptionFormScreen(
            visitId: int.tryParse(state.uri.queryParameters['visitId'] ?? ''),
            patientId: int.tryParse(state.uri.queryParameters['patientId'] ?? ''),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.prescriptionDetail,
        builder: (context, state) => BlocProvider(
          create: (_) => GetIt.I<PrescriptionDetailCubit>(),
          child: PrescriptionDetailScreen(
            prescriptionId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.prescriptionEdit,
        builder: (context, state) => BlocProvider(
          create: (_) => GetIt.I<PrescriptionFormCubit>(),
          child: PrescriptionFormScreen(
            prescriptionId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.doctorChat,
        builder: (context, state) => const DoctorChatScreen(),
      ),
      GoRoute(
        path: AppRoutes.doctorNotifications,
        builder: (context, state) => const DoctorNotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.examination,
        builder: (context, state) {
          final visitId = int.tryParse(state.pathParameters['visitId'] ?? '') ?? 0;
          return ExaminationScreen(visitId: visitId);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScreen(child: child),
        routes: [
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
            builder: (context, state) => BlocProvider(
              create: (_) => GetIt.I<PrescriptionListCubit>(),
              child: const PrescriptionsListScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => BlocProvider(
              create: (_) => GetIt.I<ReportsCubit>()..loadReports(),
              child: const DoctorReportsScreen(),
            ),
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
            builder: (context, state) => BlocProvider(
              create: (_) => GetIt.I<ProfileCubit>(),
              child: const DoctorProfileScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.reception,
            builder: (_, _) => const PlaceholderShellContent(titleKey: 'shell.reception', icon: AppIcons.reception),
          ),
          GoRoute(
            path: AppRoutes.appointments,
            builder: (_, _) => const PlaceholderShellContent(titleKey: 'shell.appointments', icon: AppIcons.appointments),
          ),
          GoRoute(
            path: AppRoutes.financial,
            builder: (_, _) => const PlaceholderShellContent(titleKey: 'shell.financial', icon: AppIcons.financial),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (_, _) => const PlaceholderShellContent(titleKey: 'shell.settings', icon: AppIcons.settings),
          ),
        ],
      ),
    ],
  );
}
