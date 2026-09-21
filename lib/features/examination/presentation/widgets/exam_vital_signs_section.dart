import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/vital_signs_entity.dart';
import 'exam_section_card.dart';
import 'vital_sign_item.dart';

class ExamVitalSignsSection extends StatelessWidget {
  final VitalSignsEntity? vitalSigns;

  const ExamVitalSignsSection({
    super.key,
    this.vitalSigns,
  });

  @override
  Widget build(BuildContext context) {
    final vitals = vitalSigns;
    final hasData = vitals != null && vitals.hasData;

    return ExamSectionCard(
      title: 'examination.vital_signs'.tr(),
      icon: Icons.monitor_heart_outlined,
      child: hasData ? _buildVitalsGrid(context, vitals) : _buildEmptyState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Text(
          'examination.no_vitals'.tr(),
          style: AppTypography.bodySmall.copyWith(
            color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
          ),
        ),
      ),
    );
  }

  Widget _buildVitalsGrid(BuildContext context, VitalSignsEntity vitals) {
    final items = <VitalSignItem>[];

    if (vitals.bloodPressure != null) {
      items.add(VitalSignItem(
        label: 'examination.bp'.tr(),
        value: vitals.bloodPressure!,
        unit: 'mmHg',
        icon: Icons.speed_rounded,
        color: AppColors.error,
      ));
    }
    if (vitals.pulse != null) {
      items.add(VitalSignItem(
        label: 'examination.pulse'.tr(),
        value: '${vitals.pulse}',
        unit: 'bpm',
        icon: Icons.favorite_rounded,
        color: AppColors.error,
      ));
    }
    if (vitals.temperature != null) {
      items.add(VitalSignItem(
        label: 'examination.temp'.tr(),
        value: '${vitals.temperature}',
        unit: '°C',
        icon: Icons.thermostat_rounded,
        color: AppColors.accent,
      ));
    }
    if (vitals.oxygenLevel != null) {
      items.add(VitalSignItem(
        label: 'examination.o2'.tr(),
        value: '${vitals.oxygenLevel}',
        unit: '%',
        icon: Icons.air_rounded,
        color: AppColors.info,
      ));
    }
    if (vitals.weightKg != null) {
      items.add(VitalSignItem(
        label: 'examination.weight'.tr(),
        value: '${vitals.weightKg}',
        unit: 'kg',
        icon: Icons.scale_rounded,
        color: AppColors.primary,
      ));
    }
    if (vitals.heightCm != null) {
      items.add(VitalSignItem(
        label: 'examination.height'.tr(),
        value: '${vitals.heightCm}',
        unit: 'cm',
        icon: Icons.height_rounded,
        color: AppColors.primaryLight,
      ));
    }
    if (vitals.bloodSugar != null) {
      items.add(VitalSignItem(
        label: 'examination.sugar'.tr(),
        value: '${vitals.bloodSugar}',
        unit: 'mg/dL',
        icon: Icons.water_drop_rounded,
        color: AppColors.warning,
      ));
    }
    if (vitals.bmi != null) {
      items.add(VitalSignItem(
        label: 'examination.bmi'.tr(),
        value: '${vitals.bmi}',
        unit: '',
        icon: Icons.accessibility_new_rounded,
        color: AppColors.success,
      ));
    }

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: items.map((item) => _buildItemChip(context, item)).toList(),
    );
  }

  Widget _buildItemChip(BuildContext context, VitalSignItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: item.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 16, color: item.color),
          const SizedBox(width: AppSpacing.xs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.label,
                style: AppTypography.caption.copyWith(
                  color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
                  fontSize: 10,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.value,
                    style: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
                    ),
                  ),
                  if (item.unit.isNotEmpty) ...[
                    const SizedBox(width: 2),
                    Text(
                      item.unit,
                      style: AppTypography.caption.copyWith(
                        fontSize: 9,
                        color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
