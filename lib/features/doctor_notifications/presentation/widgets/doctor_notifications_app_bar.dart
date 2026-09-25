import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

import 'notifications_unread_badge.dart';

class DoctorNotificationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int unreadCount;
  final bool hasNotifications;
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onBack;

  const DoctorNotificationsAppBar({
    super.key,
    required this.unreadCount,
    required this.hasNotifications,
    this.onMarkAllRead,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66.0);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isRtl = context.locale.languageCode == 'ar';

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 8,
          ),
          child: Row(
            children: [
              _buildBackButton(context, isDark, isRtl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'notifications.title'.tr(),
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: AppSpacing.xs),
                          NotificationsUnreadBadge(count: unreadCount),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'notifications.subtitle'.tr(),
                      style: AppTypography.labelSmall.copyWith(
                        color: context.textMutedColor,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasNotifications && onMarkAllRead != null) ...[
                const SizedBox(width: AppSpacing.xs),
                _buildMarkAllButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark, bool isRtl) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onBack ?? () => context.pop(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? context.surfaceVariantColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.35),
            ),
          ),
          child: Center(
            child: Icon(
              isRtl
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: context.textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkAllButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onMarkAllRead,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.done_all_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'notifications.mark_all'.tr(),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
