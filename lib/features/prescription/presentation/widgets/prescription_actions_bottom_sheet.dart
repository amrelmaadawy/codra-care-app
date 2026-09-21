import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/prescription_entity.dart';
import 'prescription_action_tile.dart';
import 'prescription_pdf_generator.dart';

class PrescriptionActionsBottomSheet extends StatefulWidget {
  final PrescriptionEntity prescription;
  final String? doctorName;
  final VoidCallback onPrinted;

  const PrescriptionActionsBottomSheet({
    super.key,
    required this.prescription,
    this.doctorName,
    required this.onPrinted,
  });

  static Future<void> show({
    required BuildContext context,
    required PrescriptionEntity prescription,
    String? doctorName,
    required VoidCallback onPrinted,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => PrescriptionActionsBottomSheet(
        prescription: prescription,
        doctorName: doctorName,
        onPrinted: onPrinted,
      ),
    );
  }

  @override
  State<PrescriptionActionsBottomSheet> createState() =>
      _PrescriptionActionsBottomSheetState();
}

class _PrescriptionActionsBottomSheetState
    extends State<PrescriptionActionsBottomSheet> {
  bool _isLoading = false;

  Future<void> _handlePrint() async {
    setState(() => _isLoading = true);
    try {
      final pdfBytes = await PrescriptionPdfGenerator.generate(
        prescription: widget.prescription,
        doctorName: widget.doctorName,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      await Printing.layoutPdf(
        onLayout: (format) async => pdfBytes,
        name: 'Rx-${widget.prescription.prescriptionNumber}.pdf',
      );
      widget.onPrinted();
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackBar.showError(context, 'prescription.pdf_error'.tr());
      }
    }
  }

  Future<void> _handleShare() async {
    setState(() => _isLoading = true);
    try {
      final pdfBytes = await PrescriptionPdfGenerator.generate(
        prescription: widget.prescription,
        doctorName: widget.doctorName,
      );
      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/prescription_${widget.prescription.prescriptionNumber}.pdf',
      );
      await file.writeAsBytes(pdfBytes);
      if (!mounted) return;
      Navigator.of(context).pop();
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'prescription.shared_title'.tr(),
      );
      widget.onPrinted();
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackBar.showError(context, 'prescription.pdf_error'.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: AppRadius.chipRadius,
                ),
              ),
            ),
            Text(
              'prescription.actions'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: context.textPrimaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: context.primaryColor),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'prescription.pdf_generating'.tr(),
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              PrescriptionActionTile(
                icon: AppIcons.print,
                title: 'prescription.print'.tr(),
                subtitle: 'prescription.print_desc'.tr(),
                color: AppColors.emerald,
                onTap: _handlePrint,
              ),
              const SizedBox(height: AppSpacing.sm),
              PrescriptionActionTile(
                icon: AppIcons.share,
                title: 'prescription.share'.tr(),
                subtitle: 'prescription.share_desc'.tr(),
                color: context.primaryColor,
                onTap: _handleShare,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
