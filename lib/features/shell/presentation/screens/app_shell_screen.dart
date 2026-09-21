import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../widgets/app_shell_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/nav_rail.dart';

class AppShellScreen extends StatelessWidget {
  final Widget child;

  const AppShellScreen({super.key, required this.child});

  List<ShellNavItem> _getNavItems(PermissionService permissions) {
    if (permissions.isDoctor) {
      return const [
        ShellNavItem(
          route: AppRoutes.doctorDashboard,
          labelKey: 'shell.dashboard',
          icon: AppIcons.dashboard,
          activeIcon: AppIcons.dashboardActive,
        ),
        ShellNavItem(
          route: AppRoutes.queue,
          labelKey: 'shell.queue',
          icon: AppIcons.queue,
          activeIcon: AppIcons.queueActive,
        ),
        ShellNavItem(
          route: AppRoutes.patients,
          labelKey: 'shell.patients',
          icon: AppIcons.patients,
          activeIcon: AppIcons.patientsActive,
        ),
        ShellNavItem(
          route: AppRoutes.prescriptions,
          labelKey: 'shell.prescriptions',
          icon: AppIcons.prescriptions,
          activeIcon: AppIcons.prescriptionsActive,
        ),
        ShellNavItem(
          route: AppRoutes.profile,
          labelKey: 'shell.profile',
          icon: AppIcons.profile,
          activeIcon: AppIcons.profileActive,
        ),
      ];
    }

    return const [
      ShellNavItem(
        route: AppRoutes.reception,
        labelKey: 'shell.reception',
        icon: AppIcons.reception,
        activeIcon: AppIcons.receptionActive,
      ),
      ShellNavItem(
        route: AppRoutes.appointments,
        labelKey: 'shell.appointments',
        icon: AppIcons.appointments,
        activeIcon: AppIcons.appointmentsActive,
      ),
      ShellNavItem(
        route: AppRoutes.patients,
        labelKey: 'shell.patients',
        icon: AppIcons.patients,
        activeIcon: AppIcons.patientsActive,
      ),
      ShellNavItem(
        route: AppRoutes.financial,
        labelKey: 'shell.financial',
        icon: AppIcons.financial,
        activeIcon: AppIcons.financialActive,
      ),
      ShellNavItem(
        route: AppRoutes.settings,
        labelKey: 'shell.settings',
        icon: AppIcons.settings,
        activeIcon: AppIcons.settingsActive,
      ),
    ];
  }

  int _calculateSelectedIndex(BuildContext context, List<ShellNavItem> items) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final permissions = GetIt.I<PermissionService>();
    final items = _getNavItems(permissions);
    final selectedIndex = _calculateSelectedIndex(context, items);
    final isMobile = ResponsiveUtils.isMobile(context);

    void onSelect(int index) {
      if (index >= 0 && index < items.length) {
        context.go(items[index].route);
      }
    }

    void onLogout() {
      context.read<AuthCubit>().logout();
    }

    final currentTitle = items[selectedIndex].labelKey.tr();
    final selectedRoute = items[selectedIndex].route;
    final hasOwnAppBar = selectedRoute == AppRoutes.doctorDashboard ||
        selectedRoute == AppRoutes.queue;

    if (isMobile) {
      return Scaffold(
        appBar: hasOwnAppBar
            ? null
            : AppShellAppBar(
                currentTitle: currentTitle,
              ),
        body: child,
        bottomNavigationBar: AppBottomNavBar(
          items: items,
          currentIndex: selectedIndex,
          onSelect: onSelect,
        ),
      );
    }

    return Scaffold(
      appBar: hasOwnAppBar
          ? null
          : AppShellAppBar(
              currentTitle: currentTitle,
            ),
      body: Row(
        children: [
          AppNavRail(
            items: items,
            currentIndex: selectedIndex,
            onSelect: onSelect,
            onLogout: onLogout,
          ),
          Expanded(
            child: Container(
              color: context.backgroundColor,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
