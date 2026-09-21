import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String doctorName;
  final String? specialization;

  const DoctorDashboardAppBar({
    super.key,
    required this.doctorName,
    this.specialization,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  String _formatName(String name) {
    final clean = name.trim();
    if (clean.startsWith('د.') || clean.startsWith('د/') || clean.startsWith('Dr.')) {
      return clean;
    }
    return '${'doctor_dashboard.welcome_prefix'.tr()} $clean';
  }

  @override
  Widget build(BuildContext context) {
    final todayFormatted = DateFormat('d MMMM', context.locale.languageCode).format(DateTime.now());
    final spec = specialization?.trim() ?? '';
    final subtitle = spec.isNotEmpty ? '$spec • $todayFormatted' : todayFormatted;

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
            height: 34,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'app_name'.tr(),
              style: AppTypography.titleLarge.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatName(doctorName),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
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
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: context.dividerColor.withValues(alpha: 0.5),
          height: 1,
        ),
      ),
    );
  }
}
