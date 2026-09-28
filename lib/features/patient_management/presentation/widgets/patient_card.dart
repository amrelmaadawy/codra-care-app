import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/patient_list_entity.dart';
import 'patient_card_info.dart';

class PatientCard extends StatelessWidget {
  final PatientListEntity patient;

  const PatientCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: context.cardShadow,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildAvatar(context),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: context.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    _buildCodeBadge(context),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: context.textMutedColor.withValues(alpha: 0.5),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          PatientCardInfo(patient: patient),
          const SizedBox(height: AppSpacing.sm),
          Divider(
            height: 1,
            thickness: 0.7,
            color: context.dividerColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildLastVisitRow(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.15),
            context.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _getInitials(patient.name),
        style: AppTypography.titleSmall.copyWith(
          color: context.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCodeBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '#${patient.code}',
        style: AppTypography.labelSmall.copyWith(
          color: context.textMutedColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.5,
        ),
      ),
    );
  }

  Widget _buildLastVisitRow(BuildContext context) {
    final hasVisit =
        patient.lastVisitDate != null &&
        patient.lastVisitDate!.trim().isNotEmpty;
    final text = hasVisit
        ? 'patients.last_visit'.tr(namedArgs: {'date': patient.lastVisitDate!})
        : 'patients.no_visits'.tr();

    return Row(
      children: [
        Icon(
          AppIcons.calendar,
          size: 13,
          color: hasVisit ? context.primaryColor : context.textMutedColor,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(
              color: hasVisit ? context.textColor : context.textMutedColor,
              fontWeight: hasVisit ? FontWeight.w500 : FontWeight.normal,
              fontSize: 11.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0].characters.first}${parts[1].characters.first}';
    }
    return trimmed.characters.take(2).toString();
  }
}
