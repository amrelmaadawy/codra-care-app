import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_follow_up_entity.dart';
import 'follow_up_instructions_section.dart';
import 'follow_up_service_due_box.dart';
import 'follow_up_urgency_badge.dart';

class FollowUpCard extends StatelessWidget {
  final ReceptionFollowUpEntity item;
  final bool isInstructionsExpanded;
  final VoidCallback onToggleInstructions;
  final VoidCallback onScheduleTap;

  const FollowUpCard({
    super.key,
    required this.item,
    required this.isInstructionsExpanded,
    required this.onToggleInstructions,
    required this.onScheduleTap,
  });

  Future<void> _makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: item.isOverdue
              ? AppColors.error.withValues(alpha: 0.3)
              : context.dividerColor.withValues(alpha: 0.6),
          width: item.isOverdue ? 1.5 : 1.0,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSpacing.sm),
            _buildDoctorAndVisitInfo(context),
            const SizedBox(height: AppSpacing.sm),
            FollowUpServiceDueBox(
              dueDate: item.dueDate,
              isOverdue: item.isOverdue,
              price: item.serviceFollowupPrice ?? item.servicePrice,
            ),
            if (item.instructions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              FollowUpInstructionsSection(
                instructions: item.instructions,
                isExpanded: isInstructionsExpanded,
                onToggle: onToggleInstructions,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            children: [
              Text(
                item.patientName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              if (item.patientCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs + 2,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: context.surfaceVariantColor,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Text(
                    item.patientCode!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: context.textMutedColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        FollowUpUrgencyBadge(
          urgency: item.urgency,
          daysDelta: item.daysDelta,
        ),
      ],
    );
  }

  Widget _buildDoctorAndVisitInfo(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 15,
          color: context.textMutedColor,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          item.doctorName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.textColor,
          ),
        ),
        if (item.doctorSpecialization.isNotEmpty) ...[
          Text(' • ', style: TextStyle(color: context.textMutedColor)),
          Text(
            item.doctorSpecialization,
            style: TextStyle(
              fontSize: 12,
              color: context.textMutedColor,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (item.patientPhone.isNotEmpty)
          IconButton.filledTonal(
            onPressed: () => _makePhoneCall(item.patientPhone),
            style: IconButton.styleFrom(
              backgroundColor: context.surfaceVariantColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            icon: const Icon(Icons.phone_outlined, size: 18),
            tooltip: item.patientPhone,
          ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: item.canSchedule ? onScheduleTap : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: context.onPrimaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            icon: const Icon(Icons.calendar_month_rounded, size: 16),
            label: Text(
              'reception_follow_ups.schedule_button'.tr(),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
