import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../domain/entities/prescription_patient_entity.dart';

class PrescriptionPatientSelector extends StatelessWidget {
  final PrescriptionPatientEntity? selectedPatient;
  final List<PrescriptionPatientEntity> availablePatients;
  final bool isLocked;
  final ValueChanged<PrescriptionPatientEntity> onSelected;

  const PrescriptionPatientSelector({
    super.key,
    required this.selectedPatient,
    required this.availablePatients,
    this.isLocked = false,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocked && selectedPatient != null) {
      return _buildLockedCard(context, selectedPatient!);
    }
    return _buildSelectorDropdown(context);
  }

  Widget _buildLockedCard(BuildContext context, PrescriptionPatientEntity patient) {
    final code = patient.patientCode?.isNotEmpty == true
        ? patient.patientCode!
        : '#${patient.id}';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.25),
          width: 1.2,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              color: context.primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  patient.fullName,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${'prescription.patient'.tr()} $code',
                      style: AppTypography.labelSmall.copyWith(
                        color: context.textSecondaryColor,
                        fontSize: 11,
                      ),
                    ),
                    if (patient.phone?.isNotEmpty == true) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          color: context.textSecondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        patient.phone!,
                        style: AppTypography.labelSmall.copyWith(
                          color: context.textSecondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 12,
                  color: context.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'prescription.visit'.tr(),
                  style: AppTypography.labelSmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorDropdown(BuildContext context) {
    return AppDropdown<PrescriptionPatientEntity>(
      initialValue: selectedPatient,
      items: availablePatients,
      labelText: 'prescription.patient'.tr(),
      sheetTitle: 'prescription.patient'.tr(),
      prefixIcon: Icons.person_search_rounded,
      itemLabel: (p) => p.fullName,
      itemSubtitle: (p) {
        final code = p.patientCode?.isNotEmpty == true ? p.patientCode! : '#${p.id}';
        final phone = p.phone?.isNotEmpty == true ? ' • ${p.phone}' : '';
        return '$code$phone';
      },
      onChanged: (p) => onSelected(p),
    );
  }
}
