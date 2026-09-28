import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/app_di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/use_cases/get_voucher_preview_use_case.dart';

class VoucherPreviewModal extends StatefulWidget {
  final int appointmentId;
  final int voucherId;

  const VoucherPreviewModal({
    super.key,
    required this.appointmentId,
    required this.voucherId,
  });

  @override
  State<VoucherPreviewModal> createState() => _VoucherPreviewModalState();
}

class _VoucherPreviewModalState extends State<VoucherPreviewModal> {
  bool _loading = true;
  Map<String, dynamic>? _voucherData;

  @override
  void initState() {
    super.initState();
    _loadVoucher();
  }

  Future<void> _loadVoucher() async {
    final useCase = getIt<GetVoucherPreviewUseCase>();
    final result = await useCase(widget.appointmentId, widget.voucherId);
    if (mounted) {
      result.fold(
        (_) => setState(() => _loading = false),
        (data) => setState(() {
          _voucherData = data;
          _loading = false;
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'payments.voucher_title'.tr(),
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
          const SizedBox(height: AppSpacing.md),
          if (_loading)
            AppShimmer(
              child: Column(
                children: [
                  AppShimmerBox(
                    height: 50,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AppShimmerBox(
                    height: 100,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ],
              ),
            )
          else if (_voucherData != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: context.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'payments.voucher_number'.tr()}: ${_voucherData!['voucher_number'] ?? ''}',
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${'payments.party_name'.tr()}: ${_voucherData!['party_name'] ?? ''}',
                    style: AppTypography.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${'payments.amount'.tr()}: ${_voucherData!['formatted_amount'] ?? _voucherData!['amount'] ?? ''}',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            labelKey: 'payments.close',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
