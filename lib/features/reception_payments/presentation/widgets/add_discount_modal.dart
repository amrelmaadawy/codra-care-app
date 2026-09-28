import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class AddDiscountModal extends StatefulWidget {
  final String maxDiscount;
  final String currencySymbol;
  final void Function(String amount, String reason) onConfirm;

  const AddDiscountModal({
    super.key,
    required this.maxDiscount,
    required this.currencySymbol,
    required this.onConfirm,
  });

  @override
  State<AddDiscountModal> createState() => _AddDiscountModalState();
}

class _AddDiscountModalState extends State<AddDiscountModal> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'payments.add_discount_title'.tr(),
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
              '${'payments.max_discount'.tr()}: ${widget.maxDiscount} ${widget.currencySymbol}',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: 'payments.discount_amount'.tr(),
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
                labelText: 'payments.discount_reason'.tr(),
                hintText: 'payments.reason_hint'.tr(),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'payments.error_enter_reason'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              labelKey: 'payments.confirm_discount',
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  widget.onConfirm(
                    _amountController.text.trim(),
                    _reasonController.text.trim(),
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
