import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

class AppDropdownField extends StatelessWidget {
  final String? labelText;
  final String displayText;
  final bool hasValue;
  final bool isOpen;
  final bool hasError;
  final String? errorText;
  final bool enabled;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? prefixWidget;

  const AppDropdownField({
    super.key,
    this.labelText,
    required this.displayText,
    required this.hasValue,
    required this.isOpen,
    required this.hasError,
    this.errorText,
    this.enabled = true,
    this.onTap,
    this.prefixIcon,
    this.prefixWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final borderColor = hasError
        ? AppColors.error
        : isOpen
            ? context.primaryColor
            : (isDark ? context.dividerColor.withValues(alpha: 0.3) : const Color(0xFFE2E8F0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.labelMedium.copyWith(
              color: hasError ? AppColors.error : context.textSecondaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
        ],
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 13),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: isOpen || hasError ? 1.4 : 1.0),
              boxShadow: [
                BoxShadow(
                  color: isOpen
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : (isDark ? Colors.black : const Color(0xFF0F172A))
                          .withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: isOpen ? 10 : 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (prefixWidget != null) ...[
                  prefixWidget!,
                  const SizedBox(width: 10),
                ] else if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    color: isOpen ? context.primaryColor : context.textMutedColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: hasValue
                          ? context.textPrimaryColor
                          : context.textMutedColor.withValues(alpha: 0.7),
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: isOpen ? context.primaryColor : context.textMutedColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasError && errorText != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: Text(
              errorText!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.error, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}
