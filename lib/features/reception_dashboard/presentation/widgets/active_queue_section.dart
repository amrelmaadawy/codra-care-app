import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/reception_doctor_summary_entity.dart';
import '../../domain/entities/reception_queue_item_entity.dart';
import 'reception_doctor_filter.dart';
import 'reception_queue_card.dart';
import 'reception_queue_empty_state.dart';
import 'reception_queue_shimmer.dart';

class ActiveQueueSection extends StatelessWidget {
  final List<ReceptionQueueItemEntity> queueItems;
  final List<ReceptionDoctorSummaryEntity> doctors;
  final int activeWaitingCount;
  final int? selectedDoctorId;
  final bool isQueueRefreshing;
  final ValueChanged<int?> onDoctorSelected;

  const ActiveQueueSection({
    super.key,
    required this.queueItems,
    required this.doctors,
    required this.activeWaitingCount,
    required this.selectedDoctorId,
    required this.isQueueRefreshing,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'reception_dashboard.active_queue'.tr(),
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2.0,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '$activeWaitingCount',
                      style: AppTypography.labelMedium.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 110),
              child: InkWell(
                onTap: () => context.push(AppRoutes.receptionQueue),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'reception_queue.title'.tr(),
                          style: AppTypography.labelMedium.copyWith(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: context.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ReceptionDoctorFilter(
          doctors: doctors,
          selectedDoctorId: selectedDoctorId,
          onDoctorSelected: onDoctorSelected,
        ),
        const SizedBox(height: AppSpacing.md),
        if (isQueueRefreshing)
          const ReceptionQueueShimmer()
        else if (queueItems.isEmpty)
          ReceptionQueueEmptyState(
            isFilteredByDoctor: selectedDoctorId != null,
            onClearFilter: () => onDoctorSelected(null),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: queueItems.length,
            itemBuilder: (context, index) {
              final item = queueItems[index];
              return ReceptionQueueCard(item: item);
            },
          ),
      ],
    );
  }
}
