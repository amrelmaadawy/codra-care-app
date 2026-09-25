import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/appointment_enums.dart';

class AppointmentFilterSheet extends StatelessWidget {
  final AppointmentStatus? selectedStatus;
  final ValueChanged<AppointmentStatus?> onStatusChanged;
  final VoidCallback onClearFilters;

  const AppointmentFilterSheet({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onClearFilters,
  });

  static Future<void> show({
    required BuildContext context,
    required AppointmentStatus? selectedStatus,
    required ValueChanged<AppointmentStatus?> onStatusChanged,
    required VoidCallback onClearFilters,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppointmentFilterSheet(
        selectedStatus: selectedStatus,
        onStatusChanged: onStatusChanged,
        onClearFilters: onClearFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'reception_appointments.filter_title'.tr(),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  onClearFilters();
                  Navigator.of(context).pop();
                },
                child: Text('reception_appointments.filter_clear'.tr()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'reception_appointments.filter_status_label'.tr(),
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: context.textMutedColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _buildStatusChip(
                context,
                label: 'reception_appointments.filter_all'.tr(),
                isSelected: selectedStatus == null,
                onTap: () {
                  onStatusChanged(null);
                  Navigator.of(context).pop();
                },
              ),
              ...AppointmentStatus.values
                  .where((s) => s != AppointmentStatus.unknown)
                  .map(
                    (status) => _buildStatusChip(
                      context,
                      label: 'reception_appointments.status_${status.name}'
                          .tr(),
                      isSelected: selectedStatus == status,
                      onTap: () {
                        onStatusChanged(status);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: context.primaryColor.withValues(alpha: 0.2),
      checkmarkColor: context.primaryColor,
      labelStyle: AppTypography.bodySmall.copyWith(
        color: isSelected ? context.primaryColor : context.textColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: context.surfaceVariantColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
        side: BorderSide(
          color: isSelected ? context.primaryColor : context.dividerColor,
        ),
      ),
    );
  }
}
