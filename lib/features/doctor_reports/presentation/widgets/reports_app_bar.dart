import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReportsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int selectedYear;
  final ValueChanged<int> onYearChanged;
  final VoidCallback onRefresh;

  const ReportsAppBar({
    super.key,
    required this.selectedYear,
    required this.onYearChanged,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 12);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  AppIcons.reports,
                  color: context.primaryColor,
                  size: AppSizes.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'doctor_reports.title'.tr(),
                      style: AppTypography.titleMedium.copyWith(
                        color: context.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'doctor_reports.subtitle'.tr(),
                      style: AppTypography.bodySmall.copyWith(
                        color: context.textSecondaryColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _buildYearSelector(context),
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: context.primaryColor,
                  size: 22,
                ),
                tooltip: 'common.refresh'.tr(),
                onPressed: onRefresh,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearSelector(BuildContext context) {
    return InkWell(
      onTap: () => _showYearPicker(context),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 14,
              color: context.primaryColor,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$selectedYear',
              style: AppTypography.bodySmall.copyWith(
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: context.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  void _showYearPicker(BuildContext context) {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => currentYear - index);

    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'doctor_reports.filter_year'.tr(),
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...years.map((year) {
                  final isSelected = year == selectedYear;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '$year',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isSelected ? context.primaryColor : context.textColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: context.primaryColor)
                        : null,
                    onTap: () {
                      Navigator.pop(ctx);
                      onYearChanged(year);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
