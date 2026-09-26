import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'app_drawer_avatar.dart';

class AppDrawerHeader extends StatelessWidget {
  final UserEntity? user;

  const AppDrawerHeader({super.key, this.user});

  String _formatName(String name, String accountType) {
    final clean = name.trim();
    if (accountType == 'doctor') {
      if (clean.startsWith('د.') || clean.startsWith('د/') || clean.startsWith('Dr.')) {
        return clean;
      }
      return '${'doctor_dashboard.welcome_prefix'.tr()} $clean';
    }
    return clean;
  }

  @override
  Widget build(BuildContext context) {
    final name = user?.name ?? 'app_name'.tr();
    final accountType = user?.accountType ?? '';
    final rawRole = user?.role ?? '';
    final roleKey = 'shell.roles.${(accountType.isNotEmpty ? accountType : rawRole).toLowerCase()}';
    final translatedRole = roleKey.tr();
    final role = translatedRole != roleKey
        ? translatedRole
        : (rawRole.isNotEmpty ? rawRole.toUpperCase() : accountType.toUpperCase());
    final phone = user?.phone ?? '';
    final email = user?.email ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? context.surfaceVariantColor.withValues(alpha: 0.35)
            : context.primaryColor.withValues(alpha: 0.05),
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md + 2,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              AppDrawerAvatar(name: name),
              const SizedBox(width: AppSpacing.md),
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
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (role.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppRadius.xs + 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              AppIcons.consultation,
                              size: 11,
                              color: context.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              role,
                              style: AppTypography.labelSmall.copyWith(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (email.isNotEmpty || phone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            email.isNotEmpty ? AppIcons.email : AppIcons.phone,
                            size: 11,
                            color: context.textMutedColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              email.isNotEmpty ? email : phone,
                              style: AppTypography.bodySmall.copyWith(
                                color: context.textMutedColor,
                                fontSize: 11,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
