import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_shell_scope.dart';

class DiagnosisTemplateListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int totalCount;

  const DiagnosisTemplateListAppBar({
    super.key,
    required this.totalCount,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return AppBar(
      automaticallyImplyLeading: false,
      leading: isMobile
          ? IconButton(
              icon: const Icon(AppIcons.menu),
              color: context.textPrimaryColor,
              onPressed: () => AppShellScope.of(context)?.openDrawer(),
              tooltip: 'shell.menu'.tr(),
            )
          : null,
      titleSpacing: isMobile ? 0 : AppSpacing.md,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'diagnosis_template.title'.tr(),
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textPrimaryColor,
            ),
          ),
          if (totalCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.chipRadius,
              ),
              child: Text(
                '$totalCount',
                style: AppTypography.caption.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      centerTitle: false,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      iconTheme: IconThemeData(color: context.textPrimaryColor),
    );
  }
}
