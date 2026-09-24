import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class ChatCharacterCounter extends StatelessWidget {
  final int currentLength;
  final int maxLength;

  const ChatCharacterCounter({
    super.key,
    required this.currentLength,
    this.maxLength = 2000,
  });

  @override
  Widget build(BuildContext context) {
    if (currentLength < 1800) {
      return const SizedBox.shrink();
    }

    final remaining = maxLength - currentLength;
    final isOverLimit = remaining <= 0;
    final isWarning = remaining < 100;

    final color = isOverLimit
        ? AppColors.error
        : (isWarning ? AppColors.warning : AppColors.onSurfaceMutedLight);

    return Padding(
      padding: const EdgeInsets.only(
        right: AppSpacing.md,
        left: AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            isOverLimit
                ? 'chat.max_char_reached'.tr()
                : 'chat.char_count'.tr(namedArgs: {'count': remaining.toString()}),
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
