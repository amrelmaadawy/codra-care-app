import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_visit_entity.dart';
import 'patient_visit_footer.dart';

class PatientVisitCard extends StatelessWidget {
  final PatientVisitEntity visit;

  const PatientVisitCard({
    super.key,
    required this.visit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: isDark
              ? context.dividerColor.withValues(alpha: 0.4)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : const Color(0xFF0F172A))
                .withValues(alpha: isDark ? 0.15 : 0.025),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          if (_hasText(visit.chiefComplaint)) ...[
            const SizedBox(height: 8),
            _buildField(
              context,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'doctor_patients.complaint'.tr(),
              value: visit.chiefComplaint!,
            ),
          ],
          if (_hasText(visit.diagnosis)) ...[
            const SizedBox(height: 6),
            _buildField(
              context,
              icon: Icons.assignment_outlined,
              label: 'doctor_patients.diagnosis'.tr(),
              value: visit.diagnosis!,
              isHighlight: true,
            ),
          ],
          if (_hasText(visit.notes)) ...[
            const SizedBox(height: 6),
            _buildField(
              context,
              icon: Icons.notes_rounded,
              label: 'doctor_patients.notes'.tr(),
              value: visit.notes!,
            ),
          ],
          const SizedBox(height: 10),
          PatientVisitFooter(visit: visit),
        ],
      ),
    );
  }

  bool _hasText(String? text) => text != null && text.trim().isNotEmpty;

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_note_rounded, size: 12, color: context.primaryColor),
              const SizedBox(width: 4),
              Text(
                visit.visitDate ?? '—',
                style: AppTypography.labelSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (visit.visitNumber != null && visit.visitNumber!.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            '#${visit.visitNumber}',
            style: AppTypography.labelSmall.copyWith(
              color: context.textMutedColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
        const Spacer(),
        if (visit.statusLabel != null && visit.statusLabel!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
            decoration: BoxDecoration(
              color: (visit.isCompleted ? AppColors.success : AppColors.info)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              visit.statusLabel!,
              style: AppTypography.labelSmall.copyWith(
                color: visit.isCompleted ? AppColors.success : AppColors.info,
                fontWeight: FontWeight.bold,
                fontSize: 10.5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: isHighlight ? context.primaryColor : context.textMutedColor),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textMutedColor,
                fontSize: 11.5,
              ),
              children: [
                TextSpan(
                  text: value,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
                    color: context.textColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
