import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/booking_patient_entity.dart';

class PatientSearchCard extends StatelessWidget {
  final BookingPatientEntity patient;
  final bool isSelected;
  final VoidCallback onSelect;

  const PatientSearchCard({
    super.key,
    required this.patient,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.07)
              : context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : context.dividerColor.withValues(alpha: 0.6),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected ? context.primaryShadow : null,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? context.primaryColor
                    : context.primaryColor.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  patient.fullName.trim().isNotEmpty ? patient.fullName.trim()[0] : 'P',
                  style: AppTypography.titleSmall.copyWith(
                    color: isSelected ? Colors.white : context.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.fullName,
                    style: AppTypography.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, size: 13, color: context.textMutedColor),
                      const SizedBox(width: 3),
                      Text(
                        patient.phone,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textMutedColor,
                          fontSize: 12,
                        ),
                      ),
                      if (patient.patientCode != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.xs),
                          ),
                          child: Text(
                            patient.patientCode!,
                            style: AppTypography.labelSmall.copyWith(
                              color: context.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.emerald : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.emerald : context.dividerColor,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
