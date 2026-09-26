import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatDateDivider extends StatelessWidget {
  final String dateText;

  const ChatDateDivider({super.key, required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xxs + 1,
          ),
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(
              alpha: context.isDarkMode ? 0.4 : 0.65,
            ),
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Text(
            dateText,
            style: AppTypography.caption.copyWith(
              color: context.subtitleColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
