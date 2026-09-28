import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../cubits/split_payment_row.dart';

class SplitPaymentRowCard extends StatelessWidget {
  final SplitPaymentRow row;
  final List<PaymentMethodEntity> paymentMethods;
  final List<BankAccountEntity> bankAccounts;
  final bool canRemove;
  final void Function(SplitPaymentRow) onRowUpdated;
  final VoidCallback onRowRemoved;

  const SplitPaymentRowCard({
    super.key,
    required this.row,
    required this.paymentMethods,
    required this.bankAccounts,
    required this.canRemove,
    required this.onRowUpdated,
    required this.onRowRemoved,
  });

  @override
  Widget build(BuildContext context) {
    PaymentMethodEntity? matched;
    for (final m in paymentMethods) {
      if (m.code == row.paymentMethod) {
        matched = m;
        break;
      }
    }
    final selectedMethod = matched ??
        (paymentMethods.isNotEmpty
            ? paymentMethods.first
            : const PaymentMethodEntity(code: 'cash', name: 'نقدي'));
    final hasMethodInList =
        paymentMethods.any((m) => m.code == selectedMethod.code);
    final initialMethodCode = hasMethodInList
        ? selectedMethod.code
        : (paymentMethods.isNotEmpty ? paymentMethods.first.code : null);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: initialMethodCode,
                  decoration: InputDecoration(
                    labelText: 'payments.method'.tr(),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.dividerColor.withValues(alpha: 0.4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.dividerColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  items: paymentMethods
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.code,
                          child: Text(
                            m.name,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      onRowUpdated(row.copyWith(paymentMethod: val));
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  initialValue: row.amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'payments.amount'.tr(),
                    filled: true,
                    fillColor: context.surfaceColor,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.dividerColor.withValues(alpha: 0.4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: context.dividerColor.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  onChanged: (val) => onRowUpdated(row.copyWith(amount: val)),
                ),
              ),
              if (canRemove)
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: AppColors.error,
                  ),
                  onPressed: onRowRemoved,
                ),
            ],
          ),
          if (selectedMethod.requiresBankAccount && bankAccounts.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            DropdownButtonFormField<int>(
              initialValue: row.bankAccountId ??
                  selectedMethod.defaultBankAccountId ??
                  bankAccounts.first.id,
              decoration: InputDecoration(
                labelText: 'payments.bank_account'.tr(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
              ),
              items: bankAccounts
                  .map(
                    (b) => DropdownMenuItem(
                      value: b.id,
                      child: Text(b.displayName),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  onRowUpdated(row.copyWith(bankAccountId: val));
                }
              },
            ),
          ],
          if (selectedMethod.requiresReference) ...[
            const SizedBox(height: AppSpacing.xs),
            TextFormField(
              initialValue: row.referenceNumber,
              decoration: InputDecoration(
                labelText: 'payments.reference_number'.tr(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
              ),
              onChanged: (val) =>
                  onRowUpdated(row.copyWith(referenceNumber: val)),
            ),
          ],
        ],
      ),
    );
  }
}
