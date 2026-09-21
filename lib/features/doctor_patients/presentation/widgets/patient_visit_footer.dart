import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_visit_entity.dart';

class PatientVisitFooter extends StatelessWidget {
  final PatientVisitEntity visit;

  const PatientVisitFooter({
    super.key,
    required this.visit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (visit.serviceName != null && visit.serviceName!.isNotEmpty)
          Text(
            visit.serviceName!,
            style: AppTypography.labelSmall.copyWith(
              color: context.textMutedColor,
              fontSize: 11,
            ),
          ),
        const Spacer(),
        if (visit.prescriptionsCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.medication_rounded, size: 11, color: AppColors.emerald),
                const SizedBox(width: 4),
                Text(
                  '${visit.prescriptionsCount} ${'doctor_patients.prescriptions'.tr()}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.emerald,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(width: 6),
        InkWell(
          onTap: () => context.push('/prescriptions/new?visitId=${visit.id}'),
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_circle_outline_rounded, size: 12, color: context.primaryColor),
                const SizedBox(width: 3),
                Text(
                  'doctor_patients.new_prescription'.tr(),
                  style: AppTypography.labelSmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
