import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientListEmptyState extends StatelessWidget {
  final bool isSearch;

  const PatientListEmptyState({
    super.key,
    this.isSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearch
                    ? Icons.person_search_rounded
                    : Icons.people_outline_rounded,
                size: 40,
                color: context.primaryColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'doctor_patients.empty_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                color: context.textColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isSearch
                  ? 'doctor_patients.empty_search_desc'.tr()
                  : 'doctor_patients.empty_desc'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
