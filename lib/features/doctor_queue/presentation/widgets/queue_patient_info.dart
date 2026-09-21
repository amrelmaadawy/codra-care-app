import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_patient_entity.dart';

class QueuePatientInfo extends StatelessWidget {
  final QueuePatientEntity item;

  const QueuePatientInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final initial = item.patientName.isNotEmpty ? item.patientName.trim()[0] : 'م';
    final ageText = item.patientAge != null ? '${item.patientAge} ${'doctor_queue.age_suffix'.tr()}' : null;
    final metaItems = [item.serviceName, ageText, item.patientGender].whereType<String>().join(' • ');

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: context.primaryColor.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              initial,
              style: AppTypography.titleSmall.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.patientName,
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: context.textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                metaItems,
                style: AppTypography.bodySmall.copyWith(
                  color: context.textMutedColor,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
