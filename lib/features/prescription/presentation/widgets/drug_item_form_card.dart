import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../domain/entities/prescription_context_entity.dart';
import '../cubit/drug_item_draft.dart';
import 'drug_card_header.dart';
import 'drug_field_with_presets.dart';
import 'drug_name_field.dart';
import 'drug_route_utils.dart';

class DrugItemFormCard extends StatelessWidget {
  final int index;
  final DrugItemDraft item;
  final bool canDelete;
  final PrescriptionContextEntity contextData;
  final ValueChanged<DrugItemDraft> onChanged;
  final VoidCallback onDelete;

  const DrugItemFormCard({
    super.key,
    required this.index,
    required this.item,
    required this.canDelete,
    required this.contextData,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isValid
              ? context.primaryColor.withValues(alpha: 0.35)
              : context.dividerColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF0F172A))
                .withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrugCardHeader(
            index: index,
            drugName: item.drugName,
            canDelete: canDelete,
            onDelete: onDelete,
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          DrugNameField(
            initialValue: item.drugName,
            itemId: item.id,
            onChanged: (val) => onChanged(item.copyWith(drugName: val)),
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DrugFieldWithPresets(
                  label: 'prescription.dosage'.tr(),
                  hint: 'prescription.dosage_hint'.tr(),
                  value: item.dosage,
                  presets: contextData.quickDosages,
                  prefixIcon: Icons.medication_liquid_rounded,
                  onChanged: (val) => onChanged(item.copyWith(dosage: val)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DrugFieldWithPresets(
                  label: 'prescription.frequency'.tr(),
                  hint: 'prescription.frequency_hint'.tr(),
                  value: item.frequency,
                  presets: contextData.quickFrequencies,
                  prefixIcon: Icons.schedule_rounded,
                  onChanged: (val) => onChanged(item.copyWith(frequency: val)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DrugFieldWithPresets(
                  label: 'prescription.duration'.tr(),
                  hint: 'prescription.duration_hint'.tr(),
                  value: item.duration,
                  presets: contextData.quickDurations,
                  prefixIcon: Icons.calendar_today_rounded,
                  onChanged: (val) => onChanged(item.copyWith(duration: val)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildRouteField(context),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm + 2),
          DrugFieldWithPresets(
            label: 'prescription.instructions'.tr(),
            hint: 'prescription.instructions_hint'.tr(),
            value: item.notes,
            presets: contextData.quickNotes,
            prefixIcon: Icons.notes_rounded,
            onChanged: (val) => onChanged(item.copyWith(notes: val)),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteField(BuildContext context) {
    final options = contextData.routeOptions.isNotEmpty
        ? contextData.routeOptions
        : DrugRouteUtils.defaultRoutes;

    return AppDropdown<String>(
      labelText: 'prescription.route'.tr(),
      initialValue: item.route.isNotEmpty ? item.route : 'oral',
      items: options.keys.toList(),
      sheetTitle: 'prescription.route'.tr(),
      itemLabel: (key) => options[key] ?? key,
      itemLeading: (key) => Icon(
        DrugRouteUtils.iconForRoute(key),
        size: 18,
        color: context.primaryColor,
      ),
      prefixIcon: DrugRouteUtils.iconForRoute(item.route),
      onChanged: (val) => onChanged(item.copyWith(route: val)),
    );
  }
}
