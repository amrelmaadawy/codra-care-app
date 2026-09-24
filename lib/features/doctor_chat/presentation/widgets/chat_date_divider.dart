import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatDateDivider extends StatelessWidget {
  final String dateString;

  const ChatDateDivider({super.key, required this.dateString});

  String _formatDate(BuildContext context) {
    try {
      final date = DateTime.tryParse(dateString);
      if (date == null) return dateString;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final msgDate = DateTime(date.year, date.month, date.day);

      if (msgDate == today) {
        return 'chat.today'.tr();
      } else if (msgDate == yesterday) {
        return 'chat.yesterday'.tr();
      }
      return DateFormat('d MMMM yyyy', context.locale.languageCode).format(date);
    } catch (_) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
          borderRadius: AppRadius.chipRadius,
          border: Border.all(
            color: isDark
                ? AppColors.dividerDark.withValues(alpha: 0.6)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          _formatDate(context),
          style: AppTypography.caption.copyWith(
            color: isDark ? AppColors.onSurfaceMutedDark : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }
}
