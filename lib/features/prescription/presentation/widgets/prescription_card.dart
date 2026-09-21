import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_entity.dart';

class PrescriptionCard extends StatelessWidget {
  final PrescriptionEntity prescription;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PrescriptionCard({
    super.key,
    required this.prescription,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = prescription.createdAt != null
        ? DateFormat('yyyy/MM/dd').format(prescription.createdAt!)
        : '';

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.cardRadius,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: context.dividerColor.withValues(alpha: 0.7)),
          boxShadow: context.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.emerald.withValues(alpha: 0.12),
                    borderRadius: AppRadius.circleRadius,
                  ),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.emerald,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prescription.prescriptionNumber,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      Text(
                        dateStr,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPrintedBadge(),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert_rounded, color: context.textSecondaryColor, size: 20),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: AppSpacing.xs),
                          Text('edit'.tr()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          const SizedBox(width: AppSpacing.xs),
                          Text('delete'.tr(), style: const TextStyle(color: AppColors.error)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(color: context.dividerColor.withValues(alpha: 0.5), height: 1),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.person_outline_rounded, size: 16, color: context.textSecondaryColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          prescription.patient.fullName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: AppRadius.chipRadius,
                    border: Border.all(color: context.dividerColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.medication_outlined, size: 14, color: AppColors.emerald),
                      const SizedBox(width: 4),
                      Text(
                        '${prescription.items.length} ${'prescription.items'.tr()}',
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.w500,
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintedBadge() {
    final isPrinted = prescription.isPrinted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPrinted
            ? AppColors.emerald.withValues(alpha: 0.12)
            : AppColors.warning.withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        isPrinted ? 'prescription.printed'.tr() : 'prescription.not_printed'.tr(),
        style: AppTypography.labelSmall.copyWith(
          color: isPrinted ? AppColors.emerald : AppColors.warning,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
