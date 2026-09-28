import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/financial_currency_entity.dart';
import '../../domain/entities/financial_summary_entity.dart';

class FinancialSummaryCard extends StatelessWidget {
  final FinancialSummaryEntity summary;
  final FinancialCurrencyEntity currency;

  const FinancialSummaryCard({
    super.key,
    required this.summary,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(summary.financialStatus);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.primaryColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'payments.balance_due'.tr(),
                style: AppTypography.bodySmall.copyWith(
                  color: context.textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  'payments.status.${summary.financialStatus}'.tr(),
                  style: AppTypography.labelSmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            currency.format(summary.balance),
            style: AppTypography.headlineMedium.copyWith(
              color: summary.balance == '0.00'
                  ? AppColors.emerald
                  : AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _metricTile(
                title: 'payments.gross_charges'.tr(),
                amount: currency.format(summary.grossCharges),
                context: context,
              ),
              _metricTile(
                title: 'payments.discounts'.tr(),
                amount: currency.format(summary.discountTotal),
                context: context,
              ),
              _metricTile(
                title: 'payments.paid_total'.tr(),
                amount: currency.format(summary.payments),
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _metricTile({
    required String title,
    required String amount,
    required BuildContext context,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.labelSmall.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.success;
      case 'partially_paid':
        return AppColors.warning;
      case 'overpaid':
        return AppColors.info;
      default:
        return AppColors.error;
    }
  }
}
