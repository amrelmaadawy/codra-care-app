import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_summary_entity.dart';
import 'patient_card_footer.dart';

class PatientCard extends StatelessWidget {
  final PatientSummaryEntity patient;
  final VoidCallback onTap;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final stripeColor = patient.isFemale
        ? const Color(0xFFEC4899)
        : context.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: context.primaryColor.withValues(alpha: 0.08),
            highlightColor: context.primaryColor.withValues(alpha: 0.04),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: stripeColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 8),
                          _buildDetails(context),
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: isDark
                                ? context.dividerColor.withValues(alpha: 0.3)
                                : const Color(0xFFF1F5F9),
                          ),
                          const SizedBox(height: 8),
                          PatientCardFooter(patient: patient),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final avatarColor = patient.isFemale
        ? const Color(0xFFEC4899)
        : context.primaryColor;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: avatarColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: avatarColor.withValues(alpha: 0.25)),
          ),
          child: Icon(
            patient.isFemale ? Icons.female_rounded : Icons.male_rounded,
            color: avatarColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            patient.name,
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.2),
            ),
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
      ],
    );
  }

  Widget _buildDetails(BuildContext context) {
    final parts = <String>[];
    if (patient.age != null) {
      parts.add('${patient.age} ${'doctor_patients.years_old'.tr()}');
    }
    if (patient.genderLabel != null && patient.genderLabel!.isNotEmpty) {
      parts.add(patient.genderLabel!);
    }
    if (patient.phone != null && patient.phone!.isNotEmpty) {
      parts.add(patient.phone!);
    }

    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 13,
          color: context.textMutedColor,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            parts.isNotEmpty ? parts.join(' • ') : '—',
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
