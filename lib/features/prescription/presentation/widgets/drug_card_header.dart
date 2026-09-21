import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DrugCardHeader extends StatelessWidget {
  final int index;
  final String drugName;
  final bool canDelete;
  final VoidCallback onDelete;

  const DrugCardHeader({
    super.key,
    required this.index,
    required this.drugName,
    required this.canDelete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final title = drugName.trim().isNotEmpty
        ? '#${index + 1} • ${drugName.trim()}'
        : '${'prescription.drug_name'.tr()} #${index + 1}';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (canDelete)
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ),
      ],
    );
  }
}
