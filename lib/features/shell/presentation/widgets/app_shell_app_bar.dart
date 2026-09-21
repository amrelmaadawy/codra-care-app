import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';

class AppShellAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentTitle;

  const AppShellAppBar({
    super.key,
    required this.currentTitle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.appBarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: preferredSize.height,
          backgroundColor: context.surfaceColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: AppSpacing.lg,
          title: Row(
            children: [
              Image.asset(
                AppAssets.logoDarkTransparent,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Text(
                  'app_name'.tr(),
                  style: AppTypography.titleLarge.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                height: 16,
                width: 1,
                color: context.dividerColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  currentTitle,
                  style: AppTypography.titleMedium.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          actions: [
            if (user != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.lg),
                child: InkWell(
                  onTap: () => context.go(AppRoutes.profile),
                  borderRadius: AppRadius.circleRadius,
                  child: Container(
                    width: AppSizes.avatarMd,
                    height: AppSizes.avatarMd,
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.primaryColor.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      AppIcons.profile,
                      size: AppSizes.iconSm,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: context.dividerColor.withValues(alpha: 0.5),
              height: 1,
            ),
          ),
        );
      },
    );
  }
}
