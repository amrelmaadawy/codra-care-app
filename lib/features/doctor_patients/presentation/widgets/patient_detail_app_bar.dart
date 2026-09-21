import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? code;
  final int? patientId;

  const PatientDetailAppBar({
    super.key,
    required this.title,
    this.code,
    this.patientId,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: context.surfaceColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        color: context.textColor,
        onPressed: () => context.pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (code != null) ...[
            const SizedBox(height: 2),
            Text(
              code!,
              style: AppTypography.labelSmall.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (patientId != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
            child: TextButton.icon(
              onPressed: () =>
                  context.push('/prescriptions/new?patientId=$patientId'),
              style: TextButton.styleFrom(
                backgroundColor: context.primaryColor.withValues(alpha: 0.1),
                foregroundColor: context.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.chipRadius,
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                'doctor_patients.new_prescription'.tr(),
                style: AppTypography.labelSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: context.dividerColor.withValues(alpha: 0.4),
          height: 1,
        ),
      ),
    );
  }
}
