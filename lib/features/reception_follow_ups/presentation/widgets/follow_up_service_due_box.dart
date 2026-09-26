import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class FollowUpServiceDueBox extends StatelessWidget {
  final String? dueDate;
  final bool isOverdue;
  final double? price;

  const FollowUpServiceDueBox({
    super.key,
    required this.dueDate,
    required this.isOverdue,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.event_note_rounded,
                size: 14,
                color: context.textMutedColor,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'reception_follow_ups.due_on'.tr(args: [
                  dueDate ?? '—',
                ]),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? AppColors.error : context.textColor,
                ),
              ),
            ],
          ),
          if (price != null)
            Text(
              '$price ${'common.currency'.tr()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: context.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
