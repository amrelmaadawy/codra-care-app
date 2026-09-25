import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class AppointmentCardCheckInButton extends StatelessWidget {
  final bool isCheckingIn;
  final VoidCallback onPressed;

  const AppointmentCardCheckInButton({
    super.key,
    required this.isCheckingIn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isCheckingIn) {
      return Container(
        height: 32,
        width: 105,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          color: context.primaryColor.withValues(alpha: 0.2),
        ),
        child: const AppShimmer(
          child: AppShimmerBox(
            width: 105,
            height: 32,
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.how_to_reg_rounded, size: 15),
      label: Text(
        'reception_appointments.check_in_action'.tr(),
        style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: context.primaryColor,
        side: BorderSide(color: context.primaryColor),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        minimumSize: const Size(0, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}
