import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../cubits/split_payment_row.dart';
import 'split_payment_row_card.dart';

class SplitPaymentEditor extends StatelessWidget {
  final List<SplitPaymentRow> rows;
  final List<PaymentMethodEntity> paymentMethods;
  final List<BankAccountEntity> bankAccounts;
  final void Function(SplitPaymentRow) onRowUpdated;
  final void Function(String id) onRowRemoved;
  final VoidCallback onAddRow;

  const SplitPaymentEditor({
    super.key,
    required this.rows,
    required this.paymentMethods,
    required this.bankAccounts,
    required this.onRowUpdated,
    required this.onRowRemoved,
    required this.onAddRow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'payments.payment_details'.tr(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: onAddRow,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 16),
              label: Text(
                'payments.add_split_row'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final row = rows[index];
            return SplitPaymentRowCard(
              row: row,
              paymentMethods: paymentMethods,
              bankAccounts: bankAccounts,
              canRemove: rows.length > 1,
              onRowUpdated: onRowUpdated,
              onRowRemoved: () => onRowRemoved(row.id),
            );
          },
        ),
      ],
    );
  }
}
