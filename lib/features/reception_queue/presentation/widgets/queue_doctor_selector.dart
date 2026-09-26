import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_doctor_entity.dart';
import 'queue_doctor_selector_sheet.dart';

class QueueDoctorSelector extends StatelessWidget {
  final List<QueueDoctorEntity> doctors;
  final int? selectedDoctorId;
  final ValueChanged<int?> onDoctorSelected;
  final int? avgWaitMinutes;

  const QueueDoctorSelector({
    super.key,
    required this.doctors,
    required this.selectedDoctorId,
    required this.onDoctorSelected,
    this.avgWaitMinutes,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) return const SizedBox.shrink();

    final selectedDoc = selectedDoctorId != null
        ? doctors.where((d) => d.id == selectedDoctorId).firstOrNull
        : null;

    final label = selectedDoc != null
        ? selectedDoc.name
        : 'reception_queue.all_doctors'.tr();

    final count = selectedDoc != null
        ? selectedDoc.count
        : doctors.fold<int>(0, (sum, d) => sum + d.count);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => QueueDoctorSelectorSheet.show(
                context: context,
                doctors: doctors,
                selectedDoctorId: selectedDoctorId,
                onDoctorSelected: onDoctorSelected,
              ),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: context.surfaceVariantColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedDoctorId != null
                        ? context.primaryColor.withValues(alpha: 0.5)
                        : context.dividerColor.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedDoctorId != null
                          ? Icons.person_rounded
                          : Icons.medical_services_outlined,
                      size: 16,
                      color: context.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: selectedDoctorId != null
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: context.textPrimaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (count > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (selectedDoctorId != null)
                      GestureDetector(
                        onTap: () => onDoctorSelected(null),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: context.textSecondaryColor,
                        ),
                      )
                    else
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: context.textSecondaryColor,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (avgWaitMinutes != null && avgWaitMinutes! > 0) ...[
            const SizedBox(width: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.dividerColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: context.textSecondaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${avgWaitMinutes!} ${'reception_queue.min'.tr()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
