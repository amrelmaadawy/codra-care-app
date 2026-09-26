import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class WalkInAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WalkInAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: context.surfaceColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 20),
            color: context.textColor,
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: const Icon(Icons.bolt_rounded, size: 18, color: Colors.amber),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'reception_booking.walk_in_title'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                Text(
                  'reception_booking.walk_in_subtitle'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: context.textMutedColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: context.dividerColor.withValues(alpha: 0.4),
          height: 1,
        ),
      ),
    );
  }
}
