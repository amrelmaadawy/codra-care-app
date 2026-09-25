import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/appointment_entity.dart';
import 'appointment_check_in_summary.dart';

class AppointmentCheckInSheet extends StatefulWidget {
  final AppointmentEntity appointment;
  final bool isSubmitting;
  final void Function(String priority) onConfirm;

  const AppointmentCheckInSheet({
    super.key,
    required this.appointment,
    required this.isSubmitting,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required AppointmentEntity appointment,
    required bool isSubmitting,
    required void Function(String priority) onConfirm,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AppointmentCheckInSheet(
      appointment: appointment,
      isSubmitting: isSubmitting,
      onConfirm: onConfirm,
    ),
  );

  @override
  State<AppointmentCheckInSheet> createState() => _AppointmentCheckInSheetState();
}

class _AppointmentCheckInSheetState extends State<AppointmentCheckInSheet> {
  String _priority = 'normal';

  @override
  Widget build(BuildContext context) {
    final appt = widget.appointment;
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.how_to_reg_rounded, color: context.primaryColor, size: AppSizes.iconMd),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'reception_appointments.check_in_title'.tr(),
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, color: context.textColor),
                ),
              ),
              IconButton(
                icon: const Icon(AppIcons.close, size: AppSizes.iconMd),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppointmentCheckInSummary(appointment: appt),
          const SizedBox(height: AppSpacing.md),
          Text(
            'reception_appointments.priority_label'.tr(),
            style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600, color: context.textColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildPrioritySelector(context),
          if (_priority == 'urgent') ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'reception_appointments.urgent_priority_note'.tr(),
              style: AppTypography.labelSmall.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildPrioritySelector(BuildContext context) {
    final priorities = [
      ('normal', 'reception_appointments.priority_normal'.tr()),
      ('urgent', 'reception_appointments.priority_urgent'.tr()),
      ('vip', 'reception_appointments.priority_vip'.tr()),
    ];

    return Row(
      children: priorities.map((p) {
        final selected = _priority == p.$1;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(p.$2),
              selected: selected,
              onSelected: widget.isSubmitting ? null : (_) => setState(() => _priority = p.$1),
              selectedColor: context.primaryColor.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: selected ? context.primaryColor : context.textColor,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    if (widget.isSubmitting) {
      return Container(
        height: AppSizes.minTouchTarget,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          color: context.primaryColor.withValues(alpha: 0.3),
        ),
        child: const AppShimmer(
          child: AppShimmerBox(width: double.infinity, height: AppSizes.minTouchTarget),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => widget.onConfirm(_priority),
      icon: const Icon(Icons.check_circle_outline_rounded),
      label: Text('reception_appointments.confirm_check_in'.tr()),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }
}
