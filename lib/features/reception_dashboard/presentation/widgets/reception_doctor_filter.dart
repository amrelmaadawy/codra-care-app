import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_dropdown_sheet.dart';
import '../../domain/entities/reception_doctor_summary_entity.dart';

class ReceptionDoctorFilter extends StatelessWidget {
  final List<ReceptionDoctorSummaryEntity> doctors;
  final int? selectedDoctorId;
  final ValueChanged<int?> onDoctorSelected;

  const ReceptionDoctorFilter({
    super.key,
    required this.doctors,
    required this.selectedDoctorId,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final allDoctorsLabel = 'reception_dashboard.all_doctors'.tr();
    final selectedDoctor = selectedDoctorId == null
        ? null
        : doctors.where((d) => d.id == selectedDoctorId).firstOrNull;

    final displayText = selectedDoctor != null
        ? '${selectedDoctor.name} (${selectedDoctor.todayCount})'
        : allDoctorsLabel;

    return Semantics(
      button: true,
      label: 'reception_dashboard.filter_doctor'.tr(),
      value: displayText,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDoctorSelectionSheet(context),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: AppSizes.minTouchTarget,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: selectedDoctorId != null
                    ? context.primaryColor
                    : context.dividerColor.withValues(alpha: 0.6),
                width: selectedDoctorId != null
                    ? AppSizes.borderWidthMedium
                    : AppSizes.borderWidthThin,
              ),
              boxShadow: context.cardShadow,
            ),
            child: Row(
              children: [
                Icon(
                  AppIcons.filter,
                  size: AppSizes.iconMd,
                  color: selectedDoctorId != null
                      ? context.primaryColor
                      : context.textMutedColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: selectedDoctorId != null
                          ? context.primaryColor
                          : context.textColor,
                      fontWeight: selectedDoctorId != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedDoctorId != null)
                  SizedBox(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(AppIcons.close, size: AppSizes.iconSm),
                      color: context.textMutedColor,
                      onPressed: () => onDoctorSelected(null),
                      tooltip: 'reception_dashboard.clear_filter'.tr(),
                    ),
                  )
                else
                  Icon(Icons.arrow_drop_down, color: context.textMutedColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDoctorSelectionSheet(BuildContext context) async {
    final allOption = _DoctorOption(
      id: null,
      name: 'reception_dashboard.all_doctors'.tr(),
      count: doctors.fold<int>(0, (sum, d) => sum + d.todayCount),
    );

    final doctorOptions = doctors
        .map((d) => _DoctorOption(id: d.id, name: d.name, count: d.todayCount))
        .toList();

    final allItems = [allOption, ...doctorOptions];

    final currentSelection = allItems.firstWhere(
      (o) => o.id == selectedDoctorId,
      orElse: () => allOption,
    );

    final selected = await AppDropdownSheet.show<_DoctorOption>(
      context: context,
      title: 'reception_dashboard.filter_doctor'.tr(),
      items: allItems,
      selectedItem: currentSelection,
      itemLabel: (item) =>
          item.count != null ? '${item.name} (${item.count})' : item.name,
      isSearchable: doctors.length > 5,
    );

    if (selected != null) {
      onDoctorSelected(selected.id);
    }
  }
}

class _DoctorOption {
  final int? id;
  final String name;
  final int? count;

  const _DoctorOption({required this.id, required this.name, this.count});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _DoctorOption &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
