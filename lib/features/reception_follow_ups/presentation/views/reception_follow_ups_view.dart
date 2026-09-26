import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubits/reception_follow_ups_cubit.dart';
import '../cubits/reception_follow_ups_state.dart';
import '../widgets/follow_up_card.dart';
import '../widgets/follow_up_empty_state.dart';
import '../widgets/follow_up_error_state.dart';
import '../widgets/follow_up_filter_sheet.dart';
import '../widgets/follow_up_search_bar.dart';
import '../widgets/follow_up_shimmer_list.dart';
import '../widgets/follow_up_summary_chips.dart';
import '../widgets/reception_follow_ups_app_bar.dart';

class ReceptionFollowUpsView extends StatefulWidget {
  const ReceptionFollowUpsView({super.key});

  @override
  State<ReceptionFollowUpsView> createState() => _ReceptionFollowUpsViewState();
}

class _ReceptionFollowUpsViewState extends State<ReceptionFollowUpsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReceptionFollowUpsCubit>().loadNextPage();
    }
  }

  void _openFilterSheet(BuildContext context, ReceptionFollowUpsState state) {
    final cubit = context.read<ReceptionFollowUpsCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => FollowUpFilterSheet(
        startDate: state.params.startDate,
        endDate: state.params.endDate,
        onApply: (start, end) => cubit.setDateRange(start, end),
        onClear: () => cubit.setDateRange(null, null),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionFollowUpsCubit, ReceptionFollowUpsState>(
      builder: (context, state) {
        final cubit = context.read<ReceptionFollowUpsCubit>();

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: ReceptionFollowUpsAppBar(
            totalCount: state.summary.totalPending,
            isRefreshing: state.isSilentRefreshing,
          ),
          body: Column(
            children: [
              FollowUpSearchBar(
                onSearchChanged: cubit.onSearchChanged,
                onFilterTap: () => _openFilterSheet(context, state),
                hasActiveFilters: state.params.startDate != null ||
                    state.params.endDate != null,
              ),
              FollowUpSummaryChips(
                summary: state.summary,
                activeUrgency: state.params.urgency,
                onUrgencySelected: cubit.setUrgency,
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: _buildBody(context, state, cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ReceptionFollowUpsState state,
    ReceptionFollowUpsCubit cubit,
  ) {
    if (state.isLoading) {
      return const FollowUpShimmerList(itemCount: 6);
    }
    if (state.isError) {
      return FollowUpErrorState(
        message: state.errorMessage,
        onRetry: () => cubit.loadFollowUps(),
      );
    }
    if (state.isEmpty) {
      return FollowUpEmptyState(
        hasFilters: state.params.search != null ||
            state.params.urgency != null ||
            state.params.startDate != null,
        onResetFilters: () {
          cubit.setUrgency(null);
          cubit.setDateRange(null, null);
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: FollowUpShimmerList(itemCount: 1),
          );
        }

        final item = state.items[index];
        final isExpanded = state.expandedItemIds.contains(item.visitId);

        return FollowUpCard(
          item: item,
          isInstructionsExpanded: isExpanded,
          onToggleInstructions: () => cubit.toggleInstructions(item.visitId),
          onScheduleTap: () async {
            final result = await context.push(
              '${AppRoutes.appointmentNew}?mode=follow_up&visitId=${item.visitId}',
            );
            if (result == true && mounted) {
              cubit.loadFollowUps(silent: true);
            }
          },
        );
      },
    );
  }
}
