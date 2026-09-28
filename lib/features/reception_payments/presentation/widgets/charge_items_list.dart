import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_charge_item_entity.dart';
import '../../domain/entities/financial_currency_entity.dart';

class ChargeItemsList extends StatelessWidget {
  final List<AppointmentChargeItemEntity> charges;
  final FinancialCurrencyEntity currency;
  final bool canAddService;
  final VoidCallback onAddServicePressed;

  const ChargeItemsList({
    super.key,
    required this.charges,
    required this.currency,
    required this.canAddService,
    required this.onAddServicePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (canAddService) ...[
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onAddServicePressed,
              icon: const Icon(Icons.add, size: 18),
              label: Text('payments.add_service_button'.tr()),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        if (charges.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                'payments.no_charge_items'.tr(),
                style: AppTypography.bodyMedium.copyWith(
                  color: context.textMutedColor,
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: charges.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final item = charges[index];
              return Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: context.dividerColor),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: item.isBaseService
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Icon(
                        item.isBaseService
                            ? Icons.medical_services_outlined
                            : Icons.add_circle_outline,
                        size: 20,
                        color: item.isBaseService
                            ? AppColors.primary
                            : AppColors.info,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.quantity} × ${currency.format(item.unitPrice)}',
                            style: AppTypography.labelSmall.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      currency.format(item.totalPrice),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
