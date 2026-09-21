import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalCount;

  const PatientListAppBar({
    super.key,
    required this.totalCount,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66.0);

  @override
  Widget build(BuildContext context) {
    final todayFormatted = DateFormat(
      'EEEE، d MMMM',
      context.locale.languageCode,
    ).format(DateTime.now());

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: AppSpacing.lg,
      title: Row(
        children: [
          Image.asset(
            AppAssets.logoDarkTransparent,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'app_name'.tr(),
              style: AppTypography.titleLarge.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            height: 22,
            width: 1.2,
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'doctor_patients.title'.tr(),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: context.textMutedColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      todayFormatted,
                      style: AppTypography.labelSmall.copyWith(
                        color: context.textMutedColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (totalCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                borderRadius: AppRadius.chipRadius,
                border: Border.all(
                  color: context.primaryColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    size: 13,
                    color: context.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$totalCount',
                    style: AppTypography.labelSmall.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          InkWell(
            onTap: () => context.go(AppRoutes.profile),
            borderRadius: AppRadius.circleRadius,
            child: Container(
              width: AppSizes.avatarSm + 2,
              height: AppSizes.avatarSm + 2,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.primaryColor.withValues(alpha: 0.25),
                  width: 1.2,
                ),
              ),
              child: Icon(
                AppIcons.profile,
                size: AppSizes.iconSm,
                color: context.primaryColor,
              ),
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
