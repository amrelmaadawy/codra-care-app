import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/prescription_entity.dart';

class PrescriptionDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PrescriptionEntity? prescription;
  final VoidCallback onEdit;

  const PrescriptionDetailAppBar({
    super.key,
    this.prescription,
    required this.onEdit,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final rx = prescription;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(color: context.dividerColor.withValues(alpha: 0.5)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
          child: Row(
            children: [
              _buildBackButton(context),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rx != null ? rx.patient.fullName : 'prescription.prescription_details'.tr(),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (rx != null)
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 13,
                            color: context.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rx.prescriptionNumber,
                            style: AppTypography.labelSmall.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(context, rx.isPrinted),
                        ],
                      )
                    else
                      Text(
                        'prescription.prescription_details'.tr(),
                        style: AppTypography.labelSmall.copyWith(
                          color: context.textMutedColor,
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
              _buildEditButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.isDarkMode
              ? context.surfaceVariantColor
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.dividerColor.withValues(alpha: 0.3)),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16,
          color: context.textPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isPrinted) {
    final color = isPrinted ? context.primaryColor : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isPrinted ? 'prescription.printed'.tr() : 'prescription.not_printed'.tr(),
        style: AppTypography.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10.5,
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.25),
          ),
        ),
        child: Icon(
          Icons.edit_rounded,
          size: 18,
          color: context.primaryColor,
        ),
      ),
    );
  }
}
