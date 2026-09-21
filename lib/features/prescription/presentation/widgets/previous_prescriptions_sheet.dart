import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_entity.dart';

class PreviousPrescriptionsSheet extends StatelessWidget {
  final List<PrescriptionEntity> prescriptions;
  final ValueChanged<PrescriptionEntity> onSelect;

  const PreviousPrescriptionsSheet({
    super.key,
    required this.prescriptions,
    required this.onSelect,
  });

  static Future<void> show({
    required BuildContext context,
    required List<PrescriptionEntity> prescriptions,
    required ValueChanged<PrescriptionEntity> onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => PreviousPrescriptionsSheet(
        prescriptions: prescriptions,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: AppRadius.chipRadius,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.history_edu_rounded, color: AppColors.emerald, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'prescription.previous_prescriptions'.tr(),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (prescriptions.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(
                  child: Text(
                    'prescription.no_previous_prescriptions'.tr(),
                    style: AppTypography.bodyMedium.copyWith(color: context.textSecondaryColor),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.55),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: prescriptions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final rx = prescriptions[index];
                    final dateStr = rx.createdAt != null
                        ? DateFormat('yyyy/MM/dd').format(rx.createdAt!)
                        : '';
                    final drugsSummary = rx.items.map((e) => e.drugName).join(' • ');

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        onSelect(rx);
                      },
                      borderRadius: AppRadius.cardRadius,
                      child: Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: context.backgroundColor,
                          borderRadius: AppRadius.cardRadius,
                          border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rx.prescriptionNumber,
                                  style: AppTypography.labelLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.primaryColor,
                                  ),
                                ),
                                Text(
                                  dateStr,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: context.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            if (drugsSummary.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                drugsSummary,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall.copyWith(
                                  color: context.textPrimaryColor,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.copy_rounded, size: 14, color: AppColors.emerald),
                                const SizedBox(width: 4),
                                Text(
                                  'prescription.copy_previous'.tr(),
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.emerald,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
