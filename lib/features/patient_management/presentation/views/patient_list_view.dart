import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../cubits/patient_list_cubit.dart';
import '../cubits/patient_list_state.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_empty_state.dart';
import '../widgets/patient_error_state.dart';
import '../widgets/patient_list_shimmer.dart';
import '../widgets/patient_pagination_error_card.dart';
import '../widgets/patient_pagination_loading_card.dart';
import '../widgets/patient_search_bar.dart';

class PatientListView extends StatefulWidget {
  const PatientListView({super.key});

  @override
  State<PatientListView> createState() => _PatientListViewState();
}

class _PatientListViewState extends State<PatientListView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PatientListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PatientSearchBar(
          controller: _searchController,
          onChanged: (val) =>
              context.read<PatientListCubit>().onSearchChanged(val),
          onClear: () => context.read<PatientListCubit>().clearSearch(),
        ),
        Expanded(
          child: BlocBuilder<PatientListCubit, PatientListState>(
            builder: (context, state) {
              return switch (state) {
                PatientListInitial() ||
                PatientListLoading() => const PatientListShimmer(),
                PatientListError(:final message) => PatientErrorState(
                  message: message,
                  onRetry: () => context.read<PatientListCubit>().refresh(),
                ),
                PatientListEmpty(:final query) => PatientEmptyState(
                  searchQuery: query.search,
                  onClearSearch: () {
                    _searchController.clear();
                    context.read<PatientListCubit>().clearSearch();
                  },
                ),
                PatientListSuccess() => _buildLoadedList(context, state),
              };
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedList(BuildContext context, PatientListSuccess state) {
    final isTablet = !ResponsiveUtils.isMobile(context);

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: isTablet
              ? SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    mainAxisExtent: 175,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        PatientCard(patient: state.items[index]),
                    childCount: state.items.length,
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final itemIndex = index ~/ 2;
                      if (index.isOdd) {
                        return const SizedBox(height: AppSpacing.md);
                      }
                      return PatientCard(patient: state.items[itemIndex]);
                    },
                    childCount: state.items.isEmpty
                        ? 0
                        : state.items.length * 2 - 1,
                  ),
                ),
        ),
        if (state.isPaginating)
          const SliverToBoxAdapter(child: PatientPaginationLoadingCard()),
        if (state.paginationError != null)
          SliverToBoxAdapter(
            child: PatientPaginationErrorCard(
              message: state.paginationError!,
              onRetry: () => context.read<PatientListCubit>().loadMore(),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }
}
