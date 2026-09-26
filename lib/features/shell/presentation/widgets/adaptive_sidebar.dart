import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/di/permission_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
import '../../domain/entities/shell_destination.dart';
import '../../domain/services/shell_navigation_resolver.dart';
import 'sidebar_destination_tile.dart';
import 'sidebar_footer.dart';
import 'sidebar_header.dart';
import 'sidebar_section_header.dart';

class AdaptiveSidebar extends StatefulWidget {
  final bool isDrawer;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AdaptiveSidebar({
    super.key,
    this.isDrawer = false,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  State<AdaptiveSidebar> createState() => _AdaptiveSidebarState();
}

class _AdaptiveSidebarState extends State<AdaptiveSidebar> {
  void _onDestinationSelected(
    BuildContext context,
    ShellDestination dest,
    bool isCurrent,
  ) {
    if (widget.isDrawer) {
      Navigator.of(context).pop();
    }
    if (!isCurrent) {
      context.go(dest.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final permissions = GetIt.I<PermissionService>();
    final resolver = GetIt.I<ShellNavigationResolver>();
    final sections = resolver.resolveSections(permissions);
    final allDestinations = resolver.resolveDestinations(permissions);

    final location = GoRouterState.of(context).uri.toString();
    final activeDestination = resolver.matchDestination(
      location,
      allDestinations,
    );

    final isCollapsed = !widget.isDrawer && widget.isCollapsed;
    final sidebarWidth = widget.isDrawer
        ? AppSizes.sidebarDrawerWidth
        : (isCollapsed
            ? AppSizes.sidebarCollapsedWidth
            : AppSizes.sidebarExtendedWidth);

    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;

        final sidebarContent = Container(
          width: sidebarWidth,
          height: double.infinity,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            border: widget.isDrawer
                ? null
                : BorderDirectional(
                    end: BorderSide(
                      color: context.dividerColor.withValues(alpha: 0.6),
                    ),
                  ),
          ),
          child: Column(
            children: [
              SidebarHeader(
                user: user,
                isCollapsed: isCollapsed,
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: sections.length,
                  itemBuilder: (context, sectionIndex) {
                    final section = sections[sectionIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SidebarSectionHeader(
                          titleKey: section.labelKey,
                          isCollapsed: isCollapsed,
                        ),
                        ...section.destinations.map((dest) {
                          final isSelected =
                              activeDestination?.id == dest.id;
                          return SidebarDestinationTile(
                            destination: dest,
                            isSelected: isSelected,
                            isCollapsed: isCollapsed,
                            onTap: () => _onDestinationSelected(
                              context,
                              dest,
                              isSelected,
                            ),
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
              SidebarFooter(
                isCollapsed: isCollapsed,
                canToggleCollapse: !widget.isDrawer,
                onToggleCollapse: widget.onToggleCollapse,
              ),
            ],
          ),
        );

        if (widget.isDrawer || disableAnimations) {
          return sidebarContent;
        }

        return AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOutCubic,
          width: sidebarWidth,
          child: sidebarContent,
        );
      },
    );
  }
}
