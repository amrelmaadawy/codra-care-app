import 'package:flutter/material.dart';
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.08)
              : context.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? context.primaryColor : context.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isSelected
                  ? context.primaryColor
                  : context.surfaceVariantColor,
              child: Text(
                patient.fullName.isNotEmpty ? patient.fullName[0] : 'P',
                style: AppTypography.titleSmall.copyWith(
                  color: isSelected ? Colors.white : context.textColor,
                  fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        patient.phone,
                        style: AppTypography.bodySmall.copyWith(
                          color: context.textMutedColor,
                          fontSize: 12,
                        ),
                      ),
                      if (patient.patientCode != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${patient.patientCode}',
                          style: AppTypography.bodySmall.copyWith(
                            color: context.primaryColor,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? context.primaryColor : context.dividerColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
