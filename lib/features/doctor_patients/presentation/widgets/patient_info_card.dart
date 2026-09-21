import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_profile_info_entity.dart';

class PatientInfoCard extends StatelessWidget {
  final PatientProfileInfoEntity patient;

  const PatientInfoCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final avatarColor = patient.isFemale
        ? const Color(0xFFEC4899)
        : context.primaryColor;

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: avatarColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: avatarColor.withValues(alpha: 0.3), width: 1.5),
                ),
                child: Icon(
                  patient.isFemale ? Icons.female_rounded : Icons.male_rounded,
                  color: avatarColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            patient.code,
                            style: AppTypography.labelSmall.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        if (patient.bloodType != null && patient.bloodType!.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '🩸 ${patient.bloodType}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 1,
            color: isDark ? context.dividerColor.withValues(alpha: 0.3) : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(context),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final items = <Widget>[];
    if (patient.phone != null && patient.phone!.isNotEmpty) {
      items.add(_buildItem(context, Icons.phone_outlined, 'doctor_patients.phone'.tr(), patient.phone!));
    }
    if (patient.age != null) {
      items.add(_buildItem(context, Icons.cake_outlined, 'doctor_patients.age'.tr(), '${patient.age} ${'doctor_patients.years_old'.tr()}'));
    }
    if (patient.genderLabel != null && patient.genderLabel!.isNotEmpty) {
      items.add(_buildItem(context, Icons.person_outline_rounded, 'doctor_patients.gender'.tr(), patient.genderLabel!));
    }
    if (patient.nationalId != null && patient.nationalId!.isNotEmpty) {
      items.add(_buildItem(context, Icons.badge_outlined, 'doctor_patients.national_id'.tr(), patient.nationalId!));
    }
    if (patient.address != null && patient.address!.isNotEmpty) {
      items.add(_buildItem(context, Icons.location_on_outlined, 'doctor_patients.address'.tr(), patient.address!));
    }

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: items,
    );
  }

  Widget _buildItem(BuildContext context, IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.textMutedColor),
        const SizedBox(width: 4),
        Text('$label: ', style: AppTypography.labelSmall.copyWith(color: context.textMutedColor, fontSize: 11.5)),
        Text(value, style: AppTypography.bodySmall.copyWith(color: context.textColor, fontWeight: FontWeight.w600, fontSize: 11.5)),
      ],
    );
  }
}
