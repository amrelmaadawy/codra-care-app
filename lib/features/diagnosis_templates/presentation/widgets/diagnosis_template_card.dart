import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/diagnosis_template_entity.dart';

class DiagnosisTemplateCard extends StatelessWidget {
  final DiagnosisTemplateEntity template;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const DiagnosisTemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    this.onTap,
  });

  String? _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final dt = DateTime.tryParse(raw)?.toLocal();
    if (dt == null) return null;
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return diff.inMinutes <= 1 ? 'الآن' : 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    }
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.6),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.cardRadius,
        child: InkWell(
          borderRadius: AppRadius.cardRadius,
          onTap: onTap ?? onEdit,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                if (template.hasDiagnosis) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _buildDiagnosisBanner(context, template.diagnosis!),
                ],
                if (template.hasChiefComplaint) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildDetailRow(
                    context,
                    label: tr('diagnosis_template.fields.chief_complaint'),
                    value: template.chiefComplaint!,
                    icon: Icons.chat_bubble_outline_rounded,
                  ),
                ],
                if (template.hasNotes) ...[
                  const SizedBox(height: AppSpacing.xs),
                  _buildDetailRow(
                    context,
                    label: tr('diagnosis_template.fields.notes'),
                    value: template.notes!,
                    icon: Icons.article_outlined,
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Divider(
                  height: 1,
                  color: context.dividerColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dateStr = _formatDate(template.createdAt);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            Icons.medical_services_outlined,
            color: context.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                template.title,
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.textPrimaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (dateStr != null) ...[
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 11,
                      color: context.textMutedColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateStr,
                      style: AppTypography.caption.copyWith(
                        color: context.textMutedColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        _buildUsageBadge(context),
      ],
    );
  }

  Widget _buildUsageBadge(BuildContext context) {
    final count = template.usageCount;
    final isPopular = count >= 5;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPopular
            ? AppColors.warning.withValues(alpha: 0.12)
            : context.surfaceVariantColor,
        borderRadius: AppRadius.chipRadius,
        border: Border.all(
          color: isPopular
              ? AppColors.warning.withValues(alpha: 0.3)
              : context.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPopular ? Icons.local_fire_department_rounded : Icons.sync_alt_rounded,
            size: 12,
            color: isPopular ? AppColors.warning : context.textSecondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: isPopular ? AppColors.warning : context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisBanner(BuildContext context, String diagnosis) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border: BorderDirectional(
          start: BorderSide(color: context.primaryColor, width: 3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${tr('diagnosis_template.fields.diagnosis')}: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              diagnosis,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: context.textPrimaryColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 13, color: context.textMutedColor),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: context.textSecondaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 11, color: context.textPrimaryColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onDuplicate,
          borderRadius: BorderRadius.circular(6),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.copy_rounded, size: 14, color: context.textSecondaryColor),
                const SizedBox(width: 4),
                Text(
                  tr('diagnosis_template.actions.duplicate'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, size: 14, color: context.primaryColor),
          label: Text(
            tr('common.edit'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.primaryColor,
            ),
          ),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          tooltip: tr('common.delete'),
          icon: const Icon(Icons.delete_outline_rounded, size: 16),
          color: AppColors.error,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
