import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/queue_patient_entity.dart';
import 'queue_action_buttons.dart';
import 'queue_patient_badges.dart';
import 'queue_patient_info.dart';
import 'queue_vitals_bar.dart';

class QueuePatientCard extends StatelessWidget {
  final QueuePatientEntity item;
  final bool isCallLoading;
  final bool isCompleteLoading;
  final bool isCancelLoading;
  final bool isExamineLoading;
  final VoidCallback onCall;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final VoidCallback? onExamine;

  const QueuePatientCard({
    super.key,
    required this.item,
    this.isCallLoading = false,
    this.isCompleteLoading = false,
    this.isCancelLoading = false,
    this.isExamineLoading = false,
    required this.onCall,
    required this.onComplete,
    required this.onCancel,
    this.onExamine,
  });

  Color _getStripeColor(BuildContext context) {
    if (item.isUrgent) return AppColors.statusUrgent;
    if (item.isVip) return AppColors.warning;
    if (item.isWithDoctor) return context.primaryColor;
    if (item.isCompleted) return AppColors.success;
    return context.primaryColor.withValues(alpha: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    final stripeColor = _getStripeColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.6),
        ),
        boxShadow: context.primaryShadow,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.cardRadius,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: stripeColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 10),
                      QueuePatientInfo(item: item),
                      if (item.hasIntakeVitals && item.vitalSigns != null)
                        QueueVitalsBar(vitalSigns: item.vitalSigns!),
                      const SizedBox(height: 12),
                      QueueActionButtons(
                        isWaiting: item.isWaiting,
                        isCompleted: item.isCompleted,
                        isCallLoading: isCallLoading,
                        isCompleteLoading: isCompleteLoading,
                        isCancelLoading: isCancelLoading,
                        isExamineLoading: isExamineLoading,
                        onCall: onCall,
                        onComplete: onComplete,
                        onCancel: onCancel,
                        onExamine: onExamine,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: context.primaryColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.confirmation_number_outlined, size: 12, color: context.primaryColor),
              const SizedBox(width: 4),
              Text(
                item.ticketNumber,
                style: AppTypography.labelSmall.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (item.isUrgent || item.isVip) ...[
          const SizedBox(width: AppSpacing.xs),
          QueuePriorityBadge(isUrgent: item.isUrgent, isVip: item.isVip),
        ],
        const Spacer(),
        if (item.entryTimeHuman != null) ...[
          QueueWaitTimeBadge(timeText: item.entryTimeHuman!),
          const SizedBox(width: 6),
        ],
        QueueStatusBadge(
          isWithDoctor: item.isWithDoctor,
          isCompleted: item.isCompleted,
        ),
      ],
    );
  }
}
