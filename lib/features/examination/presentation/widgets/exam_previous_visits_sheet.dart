import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/previous_visit_entity.dart';

class ExamPreviousVisitsSheet extends StatelessWidget {
  final List<PreviousVisitEntity> previousVisits;
  final ValueChanged<int> onCopy;

  const ExamPreviousVisitsSheet({
    super.key,
    required this.previousVisits,
    required this.onCopy,
  });

  static void show(
    BuildContext context, {
    required List<PreviousVisitEntity> previousVisits,
    required ValueChanged<int> onCopy,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => ExamPreviousVisitsSheet(
        previousVisits: previousVisits,
        onCopy: onCopy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
                  borderRadius: AppRadius.chipRadius,
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'examination.previous_visits'.tr(),
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (previousVisits.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(
                  child: Text(
                    'examination.no_previous_visits'.tr(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
                    ),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: previousVisits.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (ctx, index) => _buildVisitCard(ctx, previousVisits[index], isDark),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  Widget _buildVisitCard(BuildContext context, PreviousVisitEntity visit, bool isDark) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                visit.visitDate ?? visit.visitNumber,
                style: AppTypography.labelLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              TextButton.icon(
                onPressed: () => _confirmCopy(context, visit.id),
                icon: const Icon(Icons.copy_rounded, size: 14),
                label: Text(
                  'examination.copy_from_previous'.tr(),
                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          if (visit.chiefComplaint?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildSnippet('examination.chief_complaint'.tr(), visit.chiefComplaint!),
          ],
          if (visit.diagnosis?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildSnippet('examination.diagnosis'.tr(), visit.diagnosis!),
          ],
          if (visit.notes?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.xs),
            _buildSnippet('examination.notes'.tr(), visit.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildSnippet(String label, String value) {
    return Text.rich(
      TextSpan(
        style: AppTypography.bodySmall,
        children: [
          TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(text: value),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _confirmCopy(BuildContext context, int prevId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('examination.copy_confirm_title'.tr(), style: AppTypography.titleMedium),
        content: Text('examination.copy_confirm_msg'.tr(), style: AppTypography.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              onCopy(prevId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('examination.copy_from_previous'.tr()),
          ),
        ],
      ),
    );
  }
}
