import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_entity.dart';

class PrescriptionDetailHeaderCard extends StatelessWidget {
  final PrescriptionEntity prescription;

  const PrescriptionDetailHeaderCard({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context) {
    final rx = prescription;
    final dateStr = rx.createdAt != null
        ? DateFormat('yyyy/MM/dd – hh:mm a').format(rx.createdAt!)
        : '';

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                rx.prescriptionNumber,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.primaryColor,
                ),
              ),
              _buildPrintedBadge(context, rx.isPrinted),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            dateStr,
            style: AppTypography.bodySmall.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Divider(color: context.dividerColor.withValues(alpha: 0.5), height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: context.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${'prescription.patient'.tr()}: ',
                style: AppTypography.bodySmall.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
              Text(
                rx.patient.fullName,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrintedBadge(BuildContext context, bool isPrinted) {
    final color = isPrinted ? context.primaryColor : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        isPrinted ? 'prescription.printed'.tr() : 'prescription.not_printed'.tr(),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
