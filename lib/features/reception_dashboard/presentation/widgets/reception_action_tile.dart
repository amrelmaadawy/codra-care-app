import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isPrimary;
  final String semanticsLabel;
  final VoidCallback onTap;

  const ReceptionActionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isPrimary,
    required this.semanticsLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.primaryColor;

    final decoration = isPrimary
        ? BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                primaryColor,
                primaryColor.withValues(alpha: 0.88),
              ],
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          )
        : BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: primaryColor.withValues(alpha: 0.22),
              width: 1.2,
            ),
          );

    final titleColor = isPrimary ? Colors.white : context.textColor;
    final subtitleColor = isPrimary
        ? Colors.white.withValues(alpha: 0.85)
        : context.textMutedColor;
    final iconColor = isPrimary ? Colors.white : primaryColor;
    final iconBg = isPrimary
        ? Colors.white.withValues(alpha: 0.2)
        : primaryColor.withValues(alpha: 0.1);

    return Semantics(
      button: true,
      label: semanticsLabel,
      child: Container(
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 2,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 18, color: iconColor),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: AppTypography.labelLarge.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1),
                          Text(
                            subtitle,
                            style: AppTypography.bodySmall.copyWith(
                              color: subtitleColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 11,
                      color: isPrimary
                          ? Colors.white.withValues(alpha: 0.6)
                          : context.textMutedColor.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
