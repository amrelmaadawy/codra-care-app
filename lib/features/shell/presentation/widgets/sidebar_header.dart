import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'app_drawer_avatar.dart';

class SidebarHeader extends StatelessWidget {
  final UserEntity? user;
  final bool isCollapsed;

  const SidebarHeader({
    super.key,
    this.user,
    this.isCollapsed = false,
  });

  String _formatName(String name, String accountType) {
    final clean = name.trim();
    if (accountType == 'doctor') {
      if (clean.startsWith('د.') ||
          clean.startsWith('د/') ||
          clean.startsWith('Dr.')) {
        return clean;
      }
      return '${'doctor_dashboard.welcome_prefix'.tr()} $clean';
    }
    return clean;
  }

  String _formatRole(String role, String accountType) {
    final keyType = accountType.isNotEmpty ? accountType : role;
    if (keyType.isEmpty) return '';

    final trKey = 'shell.roles.${keyType.toLowerCase()}';
    final translated = trKey.tr();
    if (translated != trKey) return translated;

    return role.isNotEmpty ? role.toUpperCase() : accountType.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'app_name'.tr();
    final accountType = user?.accountType ?? '';
    final role = user?.role ?? '';
    final formattedRole = _formatRole(role, accountType);
    final isDark = context.isDarkMode;

    if (isCollapsed) {
      return Container(
        height: AppSizes.appBarHeight + 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
          ),
        ),
        child: Image.asset(
          AppAssets.logoDarkTransparent,
          height: 32,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            AppIcons.clinic,
            size: AppSizes.iconLg,
            color: context.primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark
            ? context.surfaceVariantColor.withValues(alpha: 0.35)
            : context.primaryColor.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              AppDrawerAvatar(name: name),
              const SizedBox(width: AppSpacing.sm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatName(name, accountType),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (formattedRole.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          formattedRole,
                          style: AppTypography.labelSmall.copyWith(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
