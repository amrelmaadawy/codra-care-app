import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';
import '../../features/auth/presentation/cubits/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/doctor_dashboard/presentation/screens/doctor_dashboard_screen.dart';
import '../../features/doctor_queue/presentation/screens/doctor_queue_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/shell/presentation/screens/app_shell_screen.dart';
import '../../features/shell/presentation/screens/placeholder_shell_content.dart';
import '../constants/app_icons.dart';
import '../di/permission_service.dart';
import '../widgets/app_loading_widget.dart';
import 'app_routes.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

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
        return permissionService.isDoctor ? AppRoutes.doctorDashboard : AppRoutes.reception;
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
      ShellRoute(
        builder: (context, state, child) => AppShellScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.shell,
            redirect: (context, state) =>
                permissionService.isDoctor ? AppRoutes.doctorDashboard : AppRoutes.reception,
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
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.patients',
              icon: AppIcons.patients,
            ),
          ),
          GoRoute(
            path: AppRoutes.prescriptions,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.prescriptions',
              icon: AppIcons.prescriptions,
            ),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.reports',
              icon: AppIcons.reports,
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.reception,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.reception',
              icon: AppIcons.reception,
            ),
          ),
          GoRoute(
            path: AppRoutes.appointments,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.appointments',
              icon: AppIcons.appointments,
            ),
          ),
          GoRoute(
            path: AppRoutes.financial,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.financial',
              icon: AppIcons.financial,
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const PlaceholderShellContent(
              titleKey: 'shell.settings',
              icon: AppIcons.settings,
            ),
          ),
        ],
      ),
    ],
  );
}
