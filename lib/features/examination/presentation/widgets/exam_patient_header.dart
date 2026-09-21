import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/visit_patient_entity.dart';

class ExamPatientHeader extends StatelessWidget {
  final VisitPatientEntity patient;
  final String visitNumber;
  final String visitTypeLabel;
  final bool isFirstVisit;
  final int pastVisitsCount;
  final VoidCallback onPreviousVisitsTap;

  const ExamPatientHeader({
    super.key,
    required this.patient,
    required this.visitNumber,
    required this.visitTypeLabel,
    required this.isFirstVisit,
    required this.pastVisitsCount,
    required this.onPreviousVisitsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.cardRadius,
        boxShadow: AppShadows.card,
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(isDark),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.headlineSmall.copyWith(
                        color: isDark
                            ? AppColors.onBackgroundDark
                            : AppColors.onBackgroundLight,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    _buildPatientMetadata(isDark),
                  ],
                ),
              ),
              _buildVisitTypeBadge(),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(
            height: 1,
            thickness: 0.8,
            color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'examination.file_number'.tr()}: ${patient.code ?? '-'}',
                style: AppTypography.caption.copyWith(
                  color: isDark
                      ? AppColors.onSurfaceMutedDark
                      : AppColors.onSurfaceMutedLight,
                ),
              ),
              TextButton.icon(
                onPressed: onPreviousVisitsTap,
                icon: const Icon(Icons.history_rounded, size: 16),
                label: Text(
                  '${'examination.previous_visits'.tr()} ($pastVisitsCount)',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    final initials = patient.name.trim().isNotEmpty
        ? patient.name.trim().characters.first
        : '?';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTypography.headlineSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPatientMetadata(bool isDark) {
    final metaItems = <String>[];
    if (patient.age != null) {
      metaItems.add('${patient.age} ${'doctor_queue.age_suffix'.tr()}');
    }
    if (patient.gender != null && patient.gender!.isNotEmpty) {
      metaItems.add(patient.gender!);
    }
    if (patient.bloodType != null && patient.bloodType!.isNotEmpty) {
      metaItems.add(patient.bloodType!);
    }

    return Text(
      metaItems.join(' • '),
      style: AppTypography.caption.copyWith(
        color: isDark
            ? AppColors.onSurfaceMutedDark
            : AppColors.onSurfaceMutedLight,
      ),
    );
  }

  Widget _buildVisitTypeBadge() {
    final label = visitTypeLabel.isNotEmpty
        ? visitTypeLabel
        : (isFirstVisit
            ? 'examination.visit_type_first'.tr()
            : 'examination.visit_type_followup'.tr());

    final bgColor = isFirstVisit
        ? AppColors.successLight
        : AppColors.infoLight;
    final textColor = isFirstVisit
        ? AppColors.success
        : AppColors.info;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.chipRadius,
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
