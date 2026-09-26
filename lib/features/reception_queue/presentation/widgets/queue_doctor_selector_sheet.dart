import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_doctor_entity.dart';

class QueueDoctorSelectorSheet extends StatelessWidget {
  final List<QueueDoctorEntity> doctors;
  final int? selectedDoctorId;
  final ValueChanged<int?> onDoctorSelected;

  const QueueDoctorSelectorSheet({
    super.key,
    required this.doctors,
    required this.selectedDoctorId,
    required this.onDoctorSelected,
  });

  static Future<void> show({
    required BuildContext context,
    required List<QueueDoctorEntity> doctors,
    required int? selectedDoctorId,
    required ValueChanged<int?> onDoctorSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => QueueDoctorSelectorSheet(
        doctors: doctors,
        selectedDoctorId: selectedDoctorId,
        onDoctorSelected: onDoctorSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPatients = doctors.fold<int>(0, (sum, d) => sum + d.count);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: context.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 20,
                    color: context.primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'reception_queue.filter_by_doctor'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildDoctorTile(
                    context: context,
                    id: null,
                    name: 'reception_queue.all_doctors'.tr(),
                    count: totalPatients,
                    isSelected: selectedDoctorId == null,
                  ),
                  ...doctors.map(
                    (doc) => _buildDoctorTile(
                      context: context,
                      id: doc.id,
                      name: doc.name,
                      count: doc.count,
                      isSelected: selectedDoctorId == doc.id,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorTile({
    required BuildContext context,
    required int? id,
    required String name,
    required int count,
    required bool isSelected,
  }) {
    final primary = context.primaryColor;

    return ListTile(
      onTap: () {
        onDoctorSelected(id);
        Navigator.of(context).pop();
      },
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: isSelected
            ? primary.withValues(alpha: 0.15)
            : context.surfaceVariantColor,
        child: Icon(
          id == null ? Icons.groups_outlined : Icons.person_outline_rounded,
          size: 18,
          color: isSelected ? primary : context.textSecondaryColor,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? primary : context.textPrimaryColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? primary : context.surfaceVariantColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : context.textSecondaryColor,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.xs),
          if (isSelected)
            Icon(Icons.check_circle_rounded, color: primary, size: 20)
          else
            Icon(
              Icons.radio_button_unchecked_rounded,
              color: context.dividerColor,
              size: 20,
            ),
        ],
      ),
    );
  }
}
