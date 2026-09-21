import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class ExamPrescriptionButton extends StatelessWidget {
  final int visitId;
  final int patientId;

  const ExamPrescriptionButton({
    super.key,
    required this.visitId,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.emerald,
        side: const BorderSide(color: AppColors.emerald, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius,
        ),
      ),
      icon: const Icon(Icons.receipt_long_rounded),
      label: Text('prescription.new_prescription'.tr()),
      onPressed: () => context.push(
        '/prescriptions/new?visitId=$visitId&patientId=$patientId',
      ),
    );
  }
}
