import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';

abstract final class ShellLogoutDialog {
  static void show(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.cardRadius,
        ),
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
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
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
}
