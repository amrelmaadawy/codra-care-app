import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'doctor_dashboard.quick_actions'.tr(),
          style: AppTypography.titleMedium.copyWith(
            color: context.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.view_queue'.tr(),
                icon: AppIcons.queue,
                color: AppColors.statusWaiting,
                onTap: () => context.go(AppRoutes.queue),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.new_prescription'.tr(),
                icon: AppIcons.prescriptions,
                color: AppColors.primary,
                onTap: () => context.go(AppRoutes.prescriptions),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.patient_records'.tr(),
                icon: AppIcons.patients,
                color: AppColors.info,
                onTap: () => context.go(AppRoutes.patients),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.clinic_reports'.tr(),
                icon: AppIcons.reports,
                color: AppColors.accent,
                onTap: () => context.go(AppRoutes.reports),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.diagnosis_templates'.tr(),
                icon: Icons.assignment_outlined,
                color: AppColors.emerald,
                onTap: () => context.push(AppRoutes.diagnosisTemplates),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _QuickActionButton(
                label: 'doctor_dashboard.reception_questions'.tr(),
                icon: Icons.quiz_outlined,
                color: AppColors.primaryLight,
                onTap: () => context.push(AppRoutes.doctorQuestions),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.5),
            ),
            boxShadow: context.primaryShadow,
          ),
          child: Row(
            children: [
              Container(
                width: AppSizes.iconXl,
                height: AppSizes.iconXl,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: AppRadius.buttonRadius,
                ),
                child: Icon(icon, color: color, size: AppSizes.iconSm),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
