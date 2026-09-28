import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientEmptyState extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const PatientEmptyState({super.key, this.searchQuery, this.onClearSearch});

  @override
  Widget build(BuildContext context) {
    final isSearching = searchQuery != null && searchQuery!.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                isSearching ? AppIcons.search : AppIcons.patients,
                size: 38,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              isSearching
                  ? 'patients.no_results_title'.tr()
                  : 'patients.empty_title'.tr(),
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              isSearching
                  ? 'patients.no_results_desc'.tr(
                      namedArgs: {'query': searchQuery!},
                    )
                  : 'patients.empty_desc'.tr(),
              style: AppTypography.bodyMedium.copyWith(
                color: context.textMutedColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearching && onClearSearch != null) ...[
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: onClearSearch,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(140, 48),
                  side: BorderSide(color: context.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
                icon: const Icon(AppIcons.close, size: 16),
                label: Text('patients.clear_search'.tr()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
