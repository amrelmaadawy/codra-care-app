import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../diagnosis_templates/domain/use_cases/use_diagnosis_template_use_case.dart';
import '../../domain/entities/doctor_template_entity.dart';

class ExamTemplatePickerSheet extends StatelessWidget {
  final List<DoctorTemplateEntity> templates;
  final String title;

  const ExamTemplatePickerSheet({
    super.key,
    required this.templates,
    required this.title,
  });

  static Future<String?> show(
    BuildContext context, {
    required List<DoctorTemplateEntity> templates,
    required String title,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => ExamTemplatePickerSheet(
        templates: templates,
        title: title,
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
                const Icon(Icons.bookmark_outline_rounded, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (templates.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(
                  child: Text(
                    'examination.no_templates'.tr(),
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.onSurfaceMutedDark
                          : AppColors.onSurfaceMutedLight,
                    ),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: templates.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (ctx, index) {
                    final t = templates[index];
                    return InkWell(
                      onTap: () {
                        if (GetIt.I.isRegistered<UseDiagnosisTemplateUseCase>()) {
                          GetIt.I<UseDiagnosisTemplateUseCase>()(t.id);
                        }
                        Navigator.of(ctx).pop(t.content);
                      },
                      borderRadius: AppRadius.cardRadius,
                      child: Container(
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceVariantDark
                              : AppColors.surfaceVariantLight,
                          borderRadius: AppRadius.cardRadius,
                          border: Border.all(
                            color: isDark
                                ? AppColors.dividerDark
                                : AppColors.dividerLight,
                            width: 0.8,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.title,
                              style: AppTypography.labelLarge.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              t.content,
                              style: AppTypography.bodySmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
