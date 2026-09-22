import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../widgets/reports_app_bar.dart';
import '../widgets/reports_chart.dart';
import '../widgets/reports_month_filter.dart';
import '../widgets/reports_shimmer.dart';
import '../widgets/reports_stats_row.dart';
import '../widgets/reports_visit_list.dart';

class DoctorReportsScreen extends StatefulWidget {
  const DoctorReportsScreen({super.key});

  @override
  State<DoctorReportsScreen> createState() => _DoctorReportsScreenState();
}

class _DoctorReportsScreenState extends State<DoctorReportsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsCubit>().loadReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        final cubit = context.read<ReportsCubit>();
        final selectedYear = state is ReportsLoaded
            ? state.selectedYear
            : cubit.selectedYear;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: ReportsAppBar(
            selectedYear: selectedYear,
            onYearChanged: (year) => cubit.changeYear(year),
            onRefresh: () => cubit.refresh(),
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReportsState state) {
    if (state is ReportsInitial || state is ReportsLoading) {
      return const ReportsShimmer();
    }

    if (state is ReportsError) {
      return _buildErrorState(context, state);
    }

    if (state is ReportsLoaded) {
      final cubit = context.read<ReportsCubit>();
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            cubit.loadNextPage();
          }
          return false;
        },
        child: RefreshIndicator(
          color: context.primaryColor,
          onRefresh: () async => cubit.refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.sm),
                ReportsMonthFilter(
                  selectedMonth: state.selectedMonth,
                  onMonthSelected: (m) => cubit.changeMonth(m),
                ),
                const SizedBox(height: AppSpacing.md),
                ReportsStatsRow(
                  stats: state.stats,
                  selectedMonth: state.selectedMonth,
                ),
                const SizedBox(height: AppSpacing.md),
                ReportsChart(
                  chart: state.chart,
                  selectedMonth: state.selectedMonth,
                  onMonthSelected: (m) => cubit.changeMonth(m),
                ),
                const SizedBox(height: AppSpacing.lg),
                ReportsVisitList(
                  visits: state.visits,
                  totalVisits: state.totalVisits,
                  isLoadingMore: state.isLoadingMore,
                  onSearch: (q) => cubit.search(q),
                  onLoadMore: () => cubit.loadNextPage(),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorState(BuildContext context, ReportsError state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              state.message.startsWith('errors.')
                  ? state.message.tr()
                  : state.message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(color: context.textColor),
            ),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => context.read<ReportsCubit>().loadReports(),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
