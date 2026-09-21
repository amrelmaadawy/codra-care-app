import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PrescriptionFormAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? patientName;
  final String? patientCode;
  final int itemsCount;
  final int previousPrescriptionsCount;
  final VoidCallback? onCopyPrevious;
  final VoidCallback onBack;

  const PrescriptionFormAppBar({
    super.key,
    required this.title,
    this.patientName,
    this.patientCode,
    this.itemsCount = 0,
    this.previousPrescriptionsCount = 0,
    this.onCopyPrevious,
    required this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final hasPatient = patientName != null && patientName!.trim().isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(bottom: BorderSide(color: context.dividerColor.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
          child: Row(
            children: [
              _buildBackButton(isDark),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (hasPatient)
                      Row(
                        children: [
                          Icon(Icons.person_rounded, size: 13, color: context.primaryColor),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              patientCode != null && patientCode!.isNotEmpty
                                  ? '$patientName ($patientCode)'
                                  : patientName!,
                              style: AppTypography.labelSmall.copyWith(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'prescription.title'.tr(),
                        style: AppTypography.labelSmall.copyWith(
                          color: context.textMutedColor,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              if (itemsCount > 0) ...[
                _buildMedicationBadge(),
                const SizedBox(width: AppSpacing.xs),
              ],
              if (previousPrescriptionsCount > 0 && onCopyPrevious != null)
                _buildHistoryButton(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(bool isDark) {
    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onBack();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: isDark ? AppColors.onBackgroundDark : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildMedicationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.emerald.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emerald.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.medication_rounded, size: 13, color: AppColors.emerald),
          const SizedBox(width: 4),
          Text(
            '$itemsCount',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.emerald,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryButton(bool isDark) {
    return InkWell(
      onTap: onCopyPrevious,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_edu_rounded, size: 18, color: AppColors.emerald),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.emerald,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$previousPrescriptionsCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
