import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_doctor_entity.dart';

class QueueDoctorSelector extends StatelessWidget {
  final List<QueueDoctorEntity> doctors;
  final int? selectedDoctorId;
  final ValueChanged<int?> onDoctorSelected;

  const QueueDoctorSelector({
    super.key,
    required this.doctors,
    required this.selectedDoctorId,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildItem(
            context: context,
            label: 'reception_queue.all_doctors'.tr(),
            isSelected: selectedDoctorId == null,
            onTap: () => onDoctorSelected(null),
          ),
          ...doctors.map(
            (doc) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: _buildItem(
                context: context,
                label: doc.name,
                count: doc.count,
                isSelected: selectedDoctorId == doc.id,
                onTap: () => onDoctorSelected(
                  selectedDoctorId == doc.id ? null : doc.id,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String label,
    int? count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final primary = context.primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primary : context.dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 13,
              color: isSelected ? primary : context.textSecondaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primary : context.textPrimaryColor,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? primary : context.surfaceVariantColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : context.textSecondaryColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
