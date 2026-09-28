import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_list_entity.dart';

class PatientCardInfo extends StatelessWidget {
  final PatientListEntity patient;

  const PatientCardInfo({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final isFemale = patient.gender?.toLowerCase() == 'female';
    final genderKey = isFemale ? 'patients.gender_female' : 'patients.gender_male';
    final genderColor = isFemale ? const Color(0xFFE11D48) : const Color(0xFF0284C7);
    final ageText = patient.age != null
        ? 'patients.age_years'.tr(namedArgs: {'years': '${patient.age}'})
        : null;

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (patient.phone != null && patient.phone!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_rounded, size: 12, color: context.textMutedColor),
                const SizedBox(width: 4),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    patient.phone!,
                    style: AppTypography.bodySmall.copyWith(
                      color: context.textColor,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: genderColor.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(AppRadius.xs),
            border: Border.all(color: genderColor.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFemale ? Icons.female_rounded : Icons.male_rounded,
                size: 13,
                color: genderColor,
              ),
              const SizedBox(width: 3),
              Text(
                genderKey.tr(),
                style: AppTypography.labelSmall.copyWith(
                  color: genderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (ageText != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(AppRadius.xs),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cake_outlined, size: 12, color: context.textMutedColor),
                const SizedBox(width: 3),
                Text(
                  ageText,
                  style: AppTypography.labelSmall.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
