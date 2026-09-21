import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

class ExamCompleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ExamCompleteDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<bool?> show(BuildContext context, {required VoidCallback onConfirm}) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ExamCompleteDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.cardRadius),
      title: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'examination.complete_confirm_title'.tr(),
              style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: Text(
        'examination.complete_confirm_msg'.tr(),
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('common.cancel'.tr()),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.emerald,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
          ),
          child: Text('examination.complete_visit'.tr()),
        ),
      ],
    );
  }
}
