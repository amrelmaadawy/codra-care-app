import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/auth/presentation/cubits/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/doctor_chat/presentation/screens/doctor_chat_screen.dart';
import '../../features/doctor_notifications/presentation/screens/doctor_notifications_screen.dart';
import '../../features/doctor_patients/presentation/cubit/patient_detail_cubit.dart';
import '../../features/doctor_patients/presentation/screens/doctor_patient_detail_screen.dart';
import '../../features/examination/presentation/screens/examination_screen.dart';
import '../../features/prescription/presentation/cubit/prescription_detail_cubit.dart';
import '../../features/prescription/presentation/cubit/prescription_form_cubit.dart';
import '../../features/prescription/presentation/screens/prescription_detail_screen.dart';
import '../../features/prescription/presentation/screens/prescription_form_screen.dart';
import '../../features/reception_booking/presentation/screens/appointment_form_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../di/permission_service.dart';
import '../widgets/app_loading_widget.dart';
import 'app_routes.dart';
import 'app_shell_routes.dart';
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
      GoRoute(
        path: AppRoutes.appointmentNew,
        builder: (context, state) => AppointmentFormScreen(
          initialDate: state.uri.queryParameters['date'],
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShellScreen(child: child),
        routes: buildAppShellRoutes(permissionService),
      ),
    ],
  );
}
