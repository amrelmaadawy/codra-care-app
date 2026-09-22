import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/doctor_questions_state.dart';

class DoctorQuestionsFilterChips extends StatelessWidget {
  final DoctorQuestionsFilter selected;
  final int allCount;
  final int activeCount;
  final int inactiveCount;
  final ValueChanged<DoctorQuestionsFilter> onSelect;

  const DoctorQuestionsFilterChips({
    super.key,
    required this.selected,
    required this.allCount,
    required this.activeCount,
    required this.inactiveCount,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(
              context,
              filter: DoctorQuestionsFilter.all,
              label: tr('doctor_questions.filter_all'),
              count: allCount,
              icon: Icons.list_alt_rounded,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildChip(
              context,
              filter: DoctorQuestionsFilter.active,
              label: tr('doctor_questions.filter_active'),
              count: activeCount,
              icon: Icons.check_circle_outline_rounded,
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildChip(
              context,
              filter: DoctorQuestionsFilter.inactive,
              label: tr('doctor_questions.filter_inactive'),
              count: inactiveCount,
              icon: Icons.pause_circle_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required DoctorQuestionsFilter filter,
    required String label,
    required int count,
    required IconData icon,
  }) {
    final isSelected = selected == filter;
    final activeColor = context.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(filter),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withValues(alpha: 0.12)
                : context.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? activeColor
                  : context.dividerColor.withValues(alpha: 0.6),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? activeColor : context.textSecondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : context.textPrimaryColor,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? activeColor.withValues(alpha: 0.2)
                      : context.surfaceVariantColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? activeColor : context.textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
