import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class DoctorChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isActive;
  final bool isDark;

  const DoctorChatAppBar({
    super.key,
    required this.isActive,
    required this.isDark,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.back,
            size: 20,
            color: isDark ? AppColors.onBackgroundDark : const Color(0xFF1E293B),
          ),
        ),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007A7A), Color(0xFF005858)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF006B6B).withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  AppIcons.receptionChat,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.success : const Color(0xFF94A3B8),
                    border: Border.all(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'chat.title'.tr(),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? AppColors.onBackgroundDark : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  isActive ? 'chat.online'.tr() : 'chat.offline'.tr(),
                  style: AppTypography.caption.copyWith(
                    color: isActive ? AppColors.success : AppColors.onSurfaceMutedLight,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
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
          color: isDark
              ? AppColors.dividerDark.withValues(alpha: 0.7)
              : const Color(0xFFE2E8F0),
          height: 1,
        ),
      ),
    );
  }
}
