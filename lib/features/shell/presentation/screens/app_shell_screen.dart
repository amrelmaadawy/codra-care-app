import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';
import '../../domain/services/shell_navigation_resolver.dart';
import '../widgets/adaptive_sidebar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_shell_app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/shell_nav_items.dart';

class AppShellScreen extends StatefulWidget {
  final Widget child;

  const AppShellScreen({super.key, required this.child});

  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState extends State<AppShellScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool? _manuallyCollapsed;

  bool _isCollapsed(BuildContext context) {
    if (_manuallyCollapsed != null) return _manuallyCollapsed!;
    return ResponsiveUtils.isTablet(context);
  }

  void _toggleCollapsed(BuildContext context) {
    setState(() {
      _manuallyCollapsed = !_isCollapsed(context);
    });
  }

  bool _hasOwnAppBar(String location, bool isDoctor) {
    if (isDoctor) {
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
    return location.startsWith(AppRoutes.reception) ||
        location.startsWith(AppRoutes.appointments) ||
        location.startsWith(AppRoutes.patients) ||
        location.startsWith(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final permissions = GetIt.I<PermissionService>();
    final resolver = GetIt.I<ShellNavigationResolver>();
    final destinations = resolver.resolveDestinations(permissions);

    final location = GoRouterState.of(context).uri.toString();
    final activeDestination =
        resolver.matchDestination(location, destinations);
    final currentTitle = activeDestination != null
        ? activeDestination.labelKey.tr()
        : 'app_name'.tr();

    final isMobile = ResponsiveUtils.isMobile(context);
    final isDoctor = permissions.isDoctor;
    final hasOwnAppBar = _hasOwnAppBar(location, isDoctor);
    final isPatientsPage = location.startsWith(AppRoutes.patients);

    if (isDoctor && isMobile) {
      final items = ShellNavItems.getMobileItems(permissions);
      int selectedIndex = -1;
      for (int i = 0; i < items.length; i++) {
        if (location.startsWith(items[i].route)) {
          selectedIndex = i;
          break;
        }
      }

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
                  showProfile: !isPatientsPage,
                ),
          body: widget.child,
          bottomNavigationBar: AppBottomNavBar(
            items: items,
            currentIndex: selectedIndex,
            onSelect: (index) {
              if (index >= 0 && index < items.length) {
                context.go(items[index].route);
              }
            },
          ),
        ),
      );
    }

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
                  showProfile: !isPatientsPage,
                ),
          body: widget.child,
        ),
      );
    }

    final collapsed = _isCollapsed(context);

    return AppShellScope(
      openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: hasOwnAppBar
            ? null
            : AppShellAppBar(
                currentTitle: currentTitle,
                showProfile: !isPatientsPage,
              ),
        body: Row(
          children: [
            AdaptiveSidebar(
              isCollapsed: collapsed,
              onToggleCollapse: () => _toggleCollapsed(context),
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
