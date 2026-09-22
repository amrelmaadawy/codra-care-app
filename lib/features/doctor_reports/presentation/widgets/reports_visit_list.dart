import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/doctor_visit_report_entity.dart';
import 'reports_empty_state.dart';
import 'reports_visit_card.dart';

class ReportsVisitList extends StatelessWidget {
  final List<DoctorVisitReportEntity> visits;
  final int totalVisits;
  final bool isLoadingMore;
  final ValueChanged<String> onSearch;
  final VoidCallback onLoadMore;

  const ReportsVisitList({
    super.key,
    required this.visits,
    required this.totalVisits,
    required this.isLoadingMore,
    required this.onSearch,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'doctor_reports.visits_section'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '$totalVisits',
                  style: AppTypography.labelSmall.copyWith(
                    color: context.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSearchField(context),
          const SizedBox(height: AppSpacing.sm),
          if (visits.isEmpty)
            const ReportsEmptyState()
          else ...[
            ...visits.map((visit) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ReportsVisitCard(visit: visit),
                )),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: AppShimmerBox(width: double.infinity, height: 70),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      style: AppTypography.bodySmall.copyWith(color: context.textColor),
      decoration: InputDecoration(
        hintText: 'doctor_reports.visits_search_hint'.tr(),
        hintStyle: AppTypography.bodySmall.copyWith(
          color: context.textSecondaryColor,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 18,
          color: context.textSecondaryColor,
        ),
        filled: true,
        fillColor: context.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: context.primaryColor),
        ),
      ),
    );
  }
}
