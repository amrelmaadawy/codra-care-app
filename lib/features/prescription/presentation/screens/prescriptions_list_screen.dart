import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/prescription_list_cubit.dart';
import '../cubit/prescription_list_state.dart';
import '../widgets/prescription_card.dart';
import '../widgets/prescription_delete_dialog.dart';
import '../widgets/prescription_filter_bar.dart';
import '../widgets/prescription_list_app_bar.dart';
import '../widgets/prescription_search_bar.dart';
import '../widgets/prescription_shimmer.dart';

class PrescriptionsListScreen extends StatefulWidget {
  const PrescriptionsListScreen({super.key});

  @override
  State<PrescriptionsListScreen> createState() => _PrescriptionsListScreenState();
}

class _PrescriptionsListScreenState extends State<PrescriptionsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PrescriptionListCubit>().loadPrescriptions();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PrescriptionListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
      builder: (context, state) {
        final totalCount = state is PrescriptionListLoaded ? state.total : 0;
        final filter = state is PrescriptionListLoaded ? state.filterPrinted : null;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PrescriptionListAppBar(totalCount: totalCount),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: context.primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text('prescription.new_prescription'.tr()),
            onPressed: () => context.push('/prescriptions/new'),
          ),
          body: Column(
            children: [
              PrescriptionSearchBar(
                controller: _searchController,
                onChanged: (val) => context.read<PrescriptionListCubit>().onSearchChanged(val),
                onClear: () => context.read<PrescriptionListCubit>().loadPrescriptions(search: ''),
              ),
              PrescriptionFilterBar(
                currentFilter: filter,
                onFilterChanged: (val) => context.read<PrescriptionListCubit>().setFilterPrinted(val),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PrescriptionListState state) {
    return switch (state) {
      PrescriptionListLoading() => const PrescriptionShimmer(),
      PrescriptionListError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () => context.read<PrescriptionListCubit>().loadPrescriptions(),
        ),
      PrescriptionListEmpty() => _buildEmptyState(context),
      PrescriptionListLoaded(:final items, :final isFetchingMore) => RefreshIndicator(
          color: context.primaryColor,
          onRefresh: () => context.read<PrescriptionListCubit>().loadPrescriptions(),
          child: ListView.separated(
            controller: _scrollController,
            padding: AppSpacing.pagePadding,
            itemCount: items.length + (isFetchingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: context.primaryColor),
                    ),
                  ),
                );
              }
              final rx = items[index];
              return PrescriptionCard(
                prescription: rx,
                onTap: () => context.push('/prescriptions/${rx.id}'),
                onEdit: () => context.push('/prescriptions/${rx.id}/edit'),
                onDelete: () => _handleDelete(rx.id),
              );
            },
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_liquid_rounded, size: 56, color: context.textSecondaryColor.withValues(alpha: 0.4)),
          const SizedBox(height: AppSpacing.md),
          Text('prescription.empty_title'.tr(), style: AppTypography.titleMedium.copyWith(color: context.textPrimaryColor)),
          const SizedBox(height: 4),
          Text('prescription.empty_desc'.tr(), style: AppTypography.bodySmall.copyWith(color: context.textSecondaryColor)),
        ],
      ),
    );
  }

  Future<void> _handleDelete(int id) async {
    final confirmed = await PrescriptionDeleteDialog.show(context);
    if (confirmed == true && mounted) {
      final cubit = context.read<PrescriptionListCubit>();
      final deleted = await cubit.deletePrescription(id);
      if (deleted && mounted) {
        AppSnackBar.showSuccess(context, 'prescription.delete_success'.tr());
      }
    }
  }
}
