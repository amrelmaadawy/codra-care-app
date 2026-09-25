import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentEmptyView extends StatelessWidget {
  final VoidCallback? onNewAppointment;

  const AppointmentEmptyView({super.key, this.onNewAppointment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_outlined,
              size: 64,
              color: context.textMutedColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'reception_appointments.empty_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'reception_appointments.empty_subtitle'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onNewAppointment != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onNewAppointment,
                icon: const Icon(Icons.add, size: 18),
                label: Text('reception_appointments.new_appointment'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
