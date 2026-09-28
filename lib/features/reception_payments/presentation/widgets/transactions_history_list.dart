import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/financial_currency_entity.dart';
import '../../domain/entities/payment_transaction_entity.dart';

class TransactionsHistoryList extends StatelessWidget {
  final List<PaymentTransactionEntity> transactions;
  final FinancialCurrencyEntity currency;
  final void Function(PaymentTransactionEntity) onRefundPressed;
  final void Function(int voucherId) onViewVoucherPressed;

  const TransactionsHistoryList({
    super.key,
    required this.transactions,
    required this.currency,
    required this.onRefundPressed,
    required this.onViewVoucherPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            'payments.no_transactions'.tr(),
            style: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isRefund = tx.isRefund;
        final isDiscount = tx.isDiscount;
        final color = isRefund
            ? AppColors.error
            : isDiscount
                ? AppColors.warning
                : AppColors.success;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: context.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xxs),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Icon(
                          isRefund
                              ? Icons.undo_outlined
                              : isDiscount
                                  ? Icons.local_offer_outlined
                                  : Icons.check_circle_outline,
                          size: 16,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'payments.type.${tx.type}'.tr(),
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${isRefund ? "-" : isDiscount ? "-" : "+"}${currency.format(tx.amount)}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tx.paymentMethodLabel ?? tx.paymentMethod ?? '',
                    style: AppTypography.labelSmall.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                  if (tx.createdAt != null)
                    Text(
                      tx.createdAt!.split('T').first,
                      style: AppTypography.labelSmall.copyWith(
                        color: context.textMutedColor,
                      ),
                    ),
                ],
              ),
              if (tx.canRefund || tx.voucherId != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (tx.voucherId != null)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () => onViewVoucherPressed(tx.voucherId!),
                        icon: const Icon(Icons.receipt_outlined, size: 14),
                        label: Text(
                          'payments.receipt'.tr(),
                          style: AppTypography.labelSmall,
                        ),
                      ),
                    if (tx.canRefund)
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        onPressed: () => onRefundPressed(tx),
                        icon: const Icon(Icons.undo, size: 14),
                        label: Text(
                          'payments.refund_button'.tr(),
                          style: AppTypography.labelSmall,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
