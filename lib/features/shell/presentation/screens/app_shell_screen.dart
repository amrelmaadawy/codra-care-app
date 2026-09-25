import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_shell_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/nav_rail.dart';
import '../widgets/shell_nav_items.dart';

class AppShellScreen extends StatefulWidget {
  final Widget child;

  const AppShellScreen({super.key, required this.child});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _calculateSelectedIndex(BuildContext context, List<ShellNavItem> items) {
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < items.length; i++) {
      if (items[i].route.isNotEmpty && location.startsWith(items[i].route)) {
        return i;
      }
    }
    return -1;
  }

  static const Map<String, String> _routeTitles = {
    AppRoutes.profile: 'shell.profile',
    AppRoutes.reports: 'shell.reports',
    AppRoutes.doctorLeaveDays: 'shell.leave_days',
    AppRoutes.diagnosisTemplates: 'shell.diagnosis_templates',
    AppRoutes.doctorQuestions: 'shell.doctor_questions',
    AppRoutes.doctorDashboard: 'shell.dashboard',
    AppRoutes.queue: 'shell.queue',
    AppRoutes.patients: 'shell.patients',
    AppRoutes.prescriptions: 'shell.prescriptions',
    AppRoutes.reception: 'shell.reception',
    AppRoutes.appointments: 'shell.appointments',
    AppRoutes.financial: 'shell.financial',
    AppRoutes.settings: 'shell.settings',
  };

  String _getCurrentTitle(String location) {
    for (final entry in _routeTitles.entries) {
      if (location.startsWith(entry.key)) return entry.value.tr();
    }
    return 'app_name'.tr();
  }

  bool _hasOwnAppBar(String location) {
    return location == AppRoutes.doctorDashboard ||
        location.startsWith(AppRoutes.queue) ||
        location.startsWith(AppRoutes.patients) ||
        location.startsWith(AppRoutes.prescriptions) ||
        location.startsWith(AppRoutes.reports) ||
        location.startsWith(AppRoutes.doctorLeaveDays) ||
        location.startsWith(AppRoutes.diagnosisTemplates) ||
        location.startsWith(AppRoutes.doctorQuestions) ||
        location.startsWith(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final permissions = GetIt.I<PermissionService>();
    final isMobile = ResponsiveUtils.isMobile(context);
    final items = ShellNavItems.getMobileItems(permissions);
    final railItems = ShellNavItems.getRailItems(permissions);
    final activeItems = isMobile ? items : railItems;
    final selectedIndex = _calculateSelectedIndex(context, activeItems);

    void onSelect(int index) {
      if (index >= 0 && index < items.length) {
        context.go(items[index].route);
      }
    }

    void onRailSelect(int index) {
      if (index >= 0 && index < railItems.length) {
        context.go(railItems[index].route);
      }
    }

    void onLogout() {
      context.read<AuthCubit>().logout();
    }

    final location = GoRouterState.of(context).uri.toString();
    final currentTitle = _getCurrentTitle(location);
    final hasOwnAppBar = _hasOwnAppBar(location);

    if (isMobile) {
      return AppShellScope(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          appBar: hasOwnAppBar
              ? null
              : AppShellAppBar(
                  currentTitle: currentTitle,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          body: widget.child,
          bottomNavigationBar: AppBottomNavBar(
            items: items,
            currentIndex: selectedIndex,
            onSelect: onSelect,
          ),
        ),
      );
    }

    return AppShellScope(
      openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: hasOwnAppBar
            ? null
            : AppShellAppBar(
                currentTitle: currentTitle,
              ),
        body: Row(
          children: [
            AppNavRail(
              items: railItems,
              currentIndex: selectedIndex,
              onSelect: onRailSelect,
              onLogout: onLogout,
            ),
            Expanded(
              child: Container(
                color: context.backgroundColor,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
