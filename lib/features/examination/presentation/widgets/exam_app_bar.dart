import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/visit_patient_entity.dart';

class ExamAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VisitPatientEntity patient;
  final String? ticketNumber;
  final bool isSaving;
  final bool isSaved;
  final int pastVisitsCount;
  final VoidCallback onHistoryTap;
  final VoidCallback onBackTap;

  const ExamAppBar({
    super.key,
    required this.patient,
    this.ticketNumber,
    required this.isSaving,
    required this.isSaved,
    required this.pastVisitsCount,
    required this.onHistoryTap,
    required this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = patient.name.trim().isNotEmpty ? patient.name : 'examination.title'.tr();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 6),
          child: Row(
            children: [
              _buildBtn(onBackTap, isDark, const Icon(Icons.arrow_back_rounded, size: 20)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildTitle(name, isDark)),
              const SizedBox(width: AppSpacing.xs),
              _buildStatusBadge(),
              const SizedBox(width: AppSpacing.xs),
              _buildHistoryBtn(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBtn(VoidCallback onTap, bool isDark, Widget icon) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildTitle(String name, bool isDark) {
    final sub = ticketNumber?.isNotEmpty == true ? '$name ($ticketNumber)' : name;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'examination.title'.tr(),
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.person_outline_rounded, size: 13, color: AppColors.primary),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                sub,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    if (!isSaving && !isSaved) return const SizedBox.shrink();
    final color = isSaving ? AppColors.primary : AppColors.success;
    final text = isSaving ? 'examination.saving'.tr() : 'examination.saved'.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSaving)
            Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle))
          else
            Icon(Icons.check_circle_rounded, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.caption.copyWith(fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryBtn(bool isDark) {
    return InkWell(
      onTap: onHistoryTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
            if (pastVisitsCount > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '$pastVisitsCount',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
