import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

class AppDropdownHeader extends StatelessWidget {
  final String title;
  final int itemCount;
  final VoidCallback onClose;

  const AppDropdownHeader({
    super.key,
    required this.title,
    required this.itemCount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: context.dividerColor.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.lg,
            14,
            AppSpacing.md,
            10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.primaryColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        '$itemCount',
                        style: AppTypography.labelSmall.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onClose,
                borderRadius: AppRadius.circleRadius,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDark
                        ? context.dividerColor.withValues(alpha: 0.2)
                        : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: context.textMutedColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
