import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionPaymentSheetHeader extends StatelessWidget {
  final String? patient;
  final String? aptNumber;
  final VoidCallback onClose;

  const ReceptionPaymentSheetHeader({
    super.key,
    this.patient,
    this.aptNumber,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final title = (patient != null && patient!.trim().isNotEmpty)
        ? patient!
        : 'payments.payment_details'.tr();

    return Column(
      children: [
        const Center(
          child: ReceptionPaymentDragHandle(),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.payments_rounded, size: 20, color: context.primaryColor),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    aptNumber != null
                        ? '${'payments.payment_details'.tr()} • $aptNumber'
                        : 'payments.payment_details'.tr(),
                    style: TextStyle(fontSize: 11, color: context.textSecondaryColor),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.surfaceVariantColor.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, size: 18, color: context.textColor),
              ),
              onPressed: onClose,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.25)),
      ],
    );
  }
}

class ReceptionPaymentDragHandle extends StatelessWidget {
  const ReceptionPaymentDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      width: 36,
      height: 4,
      decoration: BoxDecoration(
        color: context.dividerColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
