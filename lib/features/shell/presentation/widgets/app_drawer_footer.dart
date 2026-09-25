import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';

class AppDrawerFooter extends StatelessWidget {
  const AppDrawerFooter({super.key});

  void _showLogoutDialog(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.surfaceColor,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
        title: Text(
          'auth.logout'.tr(),
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: dialogContext.textColor,
          ),
        ),
        content: Text(
          'auth.logout_confirmation'.tr(),
          style: AppTypography.bodyMedium.copyWith(
            color: dialogContext.textMutedColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'common.cancel'.tr(),
              style: AppTypography.labelLarge.copyWith(
                color: dialogContext.textMutedColor,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              authCubit.logout();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
            ),
            child: Text(
              'auth.logout'.tr(),
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          top: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.paddingOf(context).bottom + AppSpacing.xs,
      ),
      child: Material(
        color: AppColors.error.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => _showLogoutDialog(context),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  AppIcons.logout,
                  size: 18,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'auth.logout'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
