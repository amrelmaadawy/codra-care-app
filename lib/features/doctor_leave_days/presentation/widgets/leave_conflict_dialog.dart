import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

Future<bool?> showLeaveConflictDialog(BuildContext context, int conflicts) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('leave_days.conflict_warning_title'.tr()),
      content: Text('leave_days.conflict_warning_body'.tr(args: ['$conflicts'])),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('common.cancel'.tr()),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text('leave_days.conflict_continue'.tr()),
        ),
      ],
    ),
  );
}
