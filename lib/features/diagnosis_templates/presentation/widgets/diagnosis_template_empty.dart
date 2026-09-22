import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DiagnosisTemplateEmpty extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onAction;

  const DiagnosisTemplateEmpty({
    super.key,
    this.searchQuery,
    this.onAction,
  });

  bool get isSearch => searchQuery != null && searchQuery!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearch ? Icons.search_off_rounded : Icons.description_outlined,
                color: context.primaryColor,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isSearch
                  ? 'diagnosis_template.no_search_results'.tr()
                  : 'diagnosis_template.empty_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isSearch
                  ? 'diagnosis_template.no_search_results_msg'.tr(args: [searchQuery!])
                  : 'diagnosis_template.empty_msg'.tr(),
              style: AppTypography.bodySmall.copyWith(
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(
                  isSearch ? Icons.clear_rounded : Icons.add_rounded,
                  size: 18,
                ),
                label: Text(
                  isSearch
                      ? 'diagnosis_template.clear_filter'.tr()
                      : 'diagnosis_template.actions.add_new'.tr(),
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.chipRadius,
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
