import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants/app_durations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppSnackBarType { success, error, warning, info }

class AppSnackBar {
  const AppSnackBar._();

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context, message: message, type: AppSnackBarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message);
  }

  static void show(
    BuildContext context, {
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    Duration? duration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    final config = _getConfig(type);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        padding: EdgeInsets.zero,
        duration: duration ?? AppDurations.snackBar,
        content: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : const Color(0xFF1E293B),
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: config.color.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: config.color.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: config.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(config.icon, color: config.color, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: Text(
                  message.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              InkWell(
                onTap: () => messenger.hideCurrentSnackBar(),
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _SnackBarConfig _getConfig(AppSnackBarType type) {
    switch (type) {
      case AppSnackBarType.success:
        return const _SnackBarConfig(
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        );
      case AppSnackBarType.error:
        return const _SnackBarConfig(
          icon: Icons.error_outline_rounded,
          color: AppColors.error,
        );
      case AppSnackBarType.warning:
        return const _SnackBarConfig(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warning,
        );
      case AppSnackBarType.info:
        return const _SnackBarConfig(
          icon: Icons.info_outline_rounded,
          color: AppColors.info,
        );
    }
  }
}

class _SnackBarConfig {
  final IconData icon;
  final Color color;

  const _SnackBarConfig({required this.icon, required this.color});
}
