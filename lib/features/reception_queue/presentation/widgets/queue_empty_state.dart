import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueueEmptyState extends StatelessWidget {
  final bool isFiltered;
  final VoidCallback onClearFilters;
  final VoidCallback onRefresh;

  const QueueEmptyState({
    super.key,
    required this.isFiltered,
    required this.onClearFilters,
    required this.onRefresh,
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
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isFiltered
                    ? Icons.filter_alt_off_rounded
                    : Icons.people_outline_rounded,
                size: 54,
                color: context.primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isFiltered
                  ? 'reception_queue.empty_filtered_title'.tr()
                  : 'reception_queue.empty_queue_title'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isFiltered
                  ? 'reception_queue.empty_filtered_desc'.tr()
                  : 'reception_queue.empty_queue_desc'.tr(),
              style: TextStyle(
                fontSize: 13,
                color: context.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.tonalIcon(
              onPressed: isFiltered ? onClearFilters : onRefresh,
              icon: Icon(
                isFiltered ? Icons.filter_alt_off_rounded : Icons.refresh_rounded,
                size: 16,
              ),
              label: Text(
                isFiltered
                    ? 'reception_queue.clear_filters'.tr()
                    : 'reception_queue.refresh'.tr(),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: context.primaryColor.withValues(alpha: 0.10),
                foregroundColor: context.primaryColor,
                side: BorderSide(
                  color: context.primaryColor.withValues(alpha: 0.25),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
