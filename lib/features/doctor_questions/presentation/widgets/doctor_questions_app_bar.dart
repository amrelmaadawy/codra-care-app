import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalCount;
  final VoidCallback onPreview;
  final VoidCallback onTemplates;

  const DoctorQuestionsAppBar({
    super.key,
    required this.totalCount,
    required this.onPreview,
    required this.onTemplates,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tr('doctor_questions.title'),
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          if (totalCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.primaryColor.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                '$totalCount',
                style: AppTypography.caption.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        _AppBarActionButton(
          icon: Icons.auto_awesome_rounded,
          tooltip: tr('doctor_questions.templates_tooltip'),
          onPressed: onTemplates,
          badgeColor: AppColors.accent,
        ),
        const SizedBox(width: 8),
        _AppBarActionButton(
          icon: Icons.visibility_outlined,
          tooltip: tr('doctor_questions.preview_tooltip'),
          onPressed: onPreview,
        ),
        const SizedBox(width: 12),
      ],
      centerTitle: false,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: context.textPrimaryColor),
    );
  }
}

class _AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? badgeColor;

  const _AppBarActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = badgeColor ?? context.primaryColor;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withValues(alpha: 0.22),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
