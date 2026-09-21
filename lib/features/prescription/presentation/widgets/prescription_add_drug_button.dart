import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class PrescriptionAddDrugButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PrescriptionAddDrugButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.cardRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.emerald.withValues(alpha: 0.06),
          borderRadius: AppRadius.cardRadius,
          border: Border.all(
            color: AppColors.emerald.withValues(alpha: 0.35),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.emerald.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.emerald,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'prescription.add_drug'.tr(),
              style: AppTypography.titleSmall.copyWith(
                color: AppColors.emerald,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
