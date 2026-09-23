import '../../../../core/constants/app_icons.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import 'bottom_nav_bar.dart';

abstract final class ShellNavItems {
  static List<ShellNavItem> getMobileItems(PermissionService permissions) {
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

  static List<ShellNavItem> getRailItems(PermissionService permissions) {
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
          route: AppRoutes.reports,
          labelKey: 'shell.reports',
          icon: AppIcons.reports,
          activeIcon: AppIcons.reportsActive,
        ),
        ShellNavItem(
          route: AppRoutes.profile,
          labelKey: 'shell.profile',
          icon: AppIcons.profile,
          activeIcon: AppIcons.profileActive,
        ),
      ];
    }
    return getMobileItems(permissions);
  }
}
