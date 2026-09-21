import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_item_entity.dart';

class PrescriptionItemTile extends StatelessWidget {
  final int index;
  final PrescriptionItemEntity item;

  const PrescriptionItemTile({
    super.key,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.emerald.withValues(alpha: 0.12),
                child: Text(
                  '${index + 1}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.drugName,
                      style: AppTypography.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    if (item.route.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.route,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 4,
            children: [
              if (item.dosage.isNotEmpty)
                _buildInfoChip(Icons.straighten_rounded, item.dosage, context),
              if (item.frequency.isNotEmpty)
                _buildInfoChip(Icons.repeat_rounded, item.frequency, context),
              if (item.duration.isNotEmpty)
                _buildInfoChip(Icons.schedule_rounded, item.duration, context),
            ],
          ),
          if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: AppRadius.chipRadius,
                border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.emerald),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.notes!,
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: AppRadius.chipRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.emerald),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11,
              color: context.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
