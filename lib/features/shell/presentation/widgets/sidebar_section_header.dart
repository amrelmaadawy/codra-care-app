import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class SidebarSectionHeader extends StatelessWidget {
  final String titleKey;
  final bool isCollapsed;

  const SidebarSectionHeader({
    super.key,
    required this.titleKey,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCollapsed) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Divider(
          color: context.dividerColor.withValues(alpha: 0.4),
          height: 1,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md + 4,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Text(
        titleKey.tr().toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: context.textMutedColor.withValues(alpha: 0.8),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          fontSize: 11,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
