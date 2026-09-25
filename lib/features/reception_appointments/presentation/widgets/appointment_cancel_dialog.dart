import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';

class AppointmentCancelDialog extends StatefulWidget {
  final String patientName;
  final bool isCancelling;
  final ValueChanged<String> onConfirm;

  const AppointmentCancelDialog({
    super.key,
    required this.patientName,
    required this.isCancelling,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required String patientName,
    required bool isCancelling,
    required ValueChanged<String> onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppointmentCancelDialog(
        patientName: patientName,
        isCancelling: isCancelling,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AppointmentCancelDialog> createState() =>
      _AppointmentCancelDialogState();
}

class _AppointmentCancelDialogState extends State<AppointmentCancelDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.length < 2) {
      setState(() {
        _error = 'reception_appointments.cancel_reason_min_length'.tr();
      });
      return;
    }
    if (text.length > 300) {
      setState(() {
        _error = 'reception_appointments.cancel_reason_max_length'.tr();
      });
      return;
    }
    widget.onConfirm(text);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg + bottomInset,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'reception_appointments.cancel_appointment'.tr(),
            style: AppTypography.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'reception_appointments.cancel_confirm_message'.tr(
              args: [widget.patientName],
            ),
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            maxLines: 3,
            maxLength: 300,
            enabled: !widget.isCancelling,
            decoration: InputDecoration(
              hintText: 'reception_appointments.cancel_reason_hint'.tr(),
              errorText: _error,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.isCancelling
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text('reception_appointments.cancel_dismiss'.tr()),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: widget.isCancelling
                    ? Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                        child: const AppShimmer(
                          child: Center(child: SizedBox(width: 80, height: 16)),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _submit,
                        child: Text(
                          'reception_appointments.cancel_confirm_action'.tr(),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
