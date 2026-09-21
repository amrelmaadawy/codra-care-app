import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_summary_entity.dart';

class PatientCardFooter extends StatelessWidget {
  final PatientSummaryEntity patient;

  const PatientCardFooter({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final lastVisit = patient.lastVisitDateHuman ??
        patient.lastVisitDate ??
        'doctor_patients.no_visits'.tr();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
          decoration: BoxDecoration(
            color: AppColors.emerald.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history_rounded, size: 12, color: AppColors.emerald),
              const SizedBox(width: 4),
              Text(
                '${patient.totalVisits} ${'doctor_patients.total_visits'.tr()}',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.emerald,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 11,
                color: context.textMutedColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${'doctor_patients.last_visit'.tr()}: $lastVisit',
                  style: AppTypography.labelSmall.copyWith(
                    color: context.textMutedColor,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 12,
          color: context.textMutedColor.withValues(alpha: 0.6),
        ),
      ],
    );
  }
}
