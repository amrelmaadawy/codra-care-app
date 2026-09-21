import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_medical_history_entity.dart';

class PatientMedicalHistoryCard extends StatelessWidget {
  final PatientMedicalHistoryEntity? medicalHistory;

  const PatientMedicalHistoryCard({
    super.key,
    this.medicalHistory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final hasData = medicalHistory != null && medicalHistory!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark
              ? context.dividerColor.withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF0F172A))
                .withValues(alpha: isDark ? 0.2 : 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.health_and_safety_outlined,
                  size: 16,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'doctor_patients.medical_history'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (!hasData)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Center(
                child: Text(
                  'doctor_patients.no_medical_history'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: context.textMutedColor,
                  ),
                ),
              ),
            )
          else ...[
            if (_hasValue(medicalHistory?.chronicDiseases))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.chronic_diseases'.tr(),
                value: medicalHistory!.chronicDiseases!,
                icon: Icons.monitor_heart_outlined,
                accentColor: AppColors.error,
              ),
            if (_hasValue(medicalHistory?.allergies))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.allergies'.tr(),
                value: medicalHistory!.allergies!,
                icon: Icons.warning_amber_rounded,
                accentColor: AppColors.warning,
              ),
            if (_hasValue(medicalHistory?.previousSurgeries))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.surgeries'.tr(),
                value: medicalHistory!.previousSurgeries!,
                icon: Icons.healing_outlined,
                accentColor: AppColors.info,
              ),
            if (_hasValue(medicalHistory?.regularMedications))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.regular_medications'.tr(),
                value: medicalHistory!.regularMedications!,
                icon: Icons.medication_outlined,
                accentColor: AppColors.emerald,
              ),
            if (_hasValue(medicalHistory?.familyHistory))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.family_history'.tr(),
                value: medicalHistory!.familyHistory!,
                icon: Icons.people_outline_rounded,
                accentColor: context.primaryColor,
              ),
            if (_hasValue(medicalHistory?.specialConditions))
              _buildHistoryRow(
                context,
                title: 'doctor_patients.special_conditions'.tr(),
                value: medicalHistory!.specialConditions!,
                icon: Icons.info_outline_rounded,
                accentColor: context.textMutedColor,
              ),
          ],
        ],
      ),
    );
  }

  bool _hasValue(String? text) => text != null && text.trim().isNotEmpty;

  Widget _buildHistoryRow(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: accentColor),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textColor,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
