import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../utils/safe_tr_extension.dart';
import '../constants/app_icons.dart';
import '../constants/app_sizes.dart';
import '../error/failures.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

class AppErrorWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              AppIcons.error,
              color: AppColors.error,
              size: AppSizes.iconXl * 1.5,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              failure.message.trOrSelf(),
              style: AppTypography.bodyMedium.copyWith(
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(AppIcons.refresh, size: AppSizes.iconSm),
                label: Text('common.retry'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
