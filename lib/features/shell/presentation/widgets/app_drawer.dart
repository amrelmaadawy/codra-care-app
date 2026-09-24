import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
import 'app_drawer_footer.dart';
import 'app_drawer_header.dart';
import 'app_drawer_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Drawer(
          backgroundColor: context.surfaceColor,
          elevation: 0,
          child: Column(
            children: [
              AppDrawerHeader(user: user),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  children: [
                    const DrawerSectionHeader(titleKey: 'shell.main'),
                    DrawerItemTile(
                      icon: AppIcons.dashboard,
                      labelKey: 'shell.dashboard',
                      isSelected: location == AppRoutes.doctorDashboard,
                      onTap: () => _navigateTo(context, AppRoutes.doctorDashboard),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.queue,
                      labelKey: 'shell.queue',
                      isSelected: location.startsWith(AppRoutes.queue),
                      onTap: () => _navigateTo(context, AppRoutes.queue),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.chat,
                      labelKey: 'chat.title',
                      isSelected: location.startsWith(AppRoutes.doctorChat),
                      onTap: () => _navigateTo(context, AppRoutes.doctorChat),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const DrawerSectionHeader(titleKey: 'shell.patients_section'),
                    DrawerItemTile(
                      icon: AppIcons.patients,
                      labelKey: 'shell.patients',
                      isSelected: location.startsWith(AppRoutes.patients),
                      onTap: () => _navigateTo(context, AppRoutes.patients),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.prescriptions,
                      labelKey: 'shell.prescriptions',
                      isSelected: location.startsWith(AppRoutes.prescriptions),
                      onTap: () => _navigateTo(context, AppRoutes.prescriptions),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const DrawerSectionHeader(titleKey: 'shell.management'),
                    DrawerItemTile(
                      icon: AppIcons.reports,
                      labelKey: 'shell.reports',
                      isSelected: location.startsWith(AppRoutes.reports),
                      onTap: () => _navigateTo(context, AppRoutes.reports),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.calendar,
                      labelKey: 'shell.leave_days',
                      isSelected: location.startsWith(AppRoutes.doctorLeaveDays),
                      onTap: () => _navigateTo(context, AppRoutes.doctorLeaveDays),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.diagnosisTemplates,
                      labelKey: 'shell.diagnosis_templates',
                      isSelected: location.startsWith(AppRoutes.diagnosisTemplates),
                      onTap: () => _navigateTo(context, AppRoutes.diagnosisTemplates),
                    ),
                    DrawerItemTile(
                      icon: AppIcons.doctorQuestions,
                      labelKey: 'shell.doctor_questions',
                      isSelected: location.startsWith(AppRoutes.doctorQuestions),
                      onTap: () => _navigateTo(context, AppRoutes.doctorQuestions),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const DrawerSectionHeader(titleKey: 'shell.account'),
                    DrawerItemTile(
                      icon: AppIcons.profile,
                      labelKey: 'shell.profile',
                      isSelected: location.startsWith(AppRoutes.profile),
                      onTap: () => _navigateTo(context, AppRoutes.profile),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                  ],
                ),
              ),
              const AppDrawerFooter(),
            ],
          ),
        );
      },
    );
  }
}
