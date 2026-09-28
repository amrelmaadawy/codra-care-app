import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/payment_transaction_entity.dart';

class RefundModal extends StatefulWidget {
  final PaymentTransactionEntity transaction;
  final String currencySymbol;
  final void Function(String amount, String? reason, int paymentTransactionId)
      onConfirm;

  const RefundModal({
    super.key,
    required this.transaction,
    required this.currencySymbol,
    required this.onConfirm,
  });

  @override
  State<RefundModal> createState() => _RefundModalState();
}

class _RefundModalState extends State<RefundModal> {
  late final TextEditingController _amountController;
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction.maxRefundable ?? widget.transaction.amount,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxRefund =
        widget.transaction.maxRefundable ?? widget.transaction.amount;

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'payments.refund_title'.tr(),
                  style: AppTypography.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${'payments.max_refundable'.tr()}: $maxRefund ${widget.currencySymbol}',
              style: AppTypography.bodySmall.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'payments.refund_amount'.tr(),
                suffixText: widget.currencySymbol,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'payments.error_enter_amount'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'payments.refund_reason'.tr(),
                hintText: 'payments.reason_hint'.tr(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              labelKey: 'payments.confirm_refund',
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  widget.onConfirm(
                    _amountController.text.trim(),
                    _reasonController.text.trim(),
                    widget.transaction.id,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
