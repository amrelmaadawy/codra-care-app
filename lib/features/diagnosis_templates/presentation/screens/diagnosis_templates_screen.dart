import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/diagnosis_template_entity.dart';
import '../cubit/diagnosis_template_list_cubit.dart';
import '../cubit/diagnosis_template_list_state.dart';
import '../widgets/diagnosis_template_card.dart';
import '../widgets/diagnosis_template_delete_dialog.dart';
import '../widgets/diagnosis_template_empty.dart';
import '../widgets/diagnosis_template_form_sheet.dart';
import '../widgets/diagnosis_template_list_app_bar.dart';
import '../widgets/diagnosis_template_quick_chips.dart';
import '../widgets/diagnosis_template_search_bar.dart';
import '../widgets/diagnosis_template_shimmer.dart';

class DiagnosisTemplatesScreen extends StatefulWidget {
  const DiagnosisTemplatesScreen({super.key});

  @override
  State<DiagnosisTemplatesScreen> createState() =>
      _DiagnosisTemplatesScreenState();
}

class _DiagnosisTemplatesScreenState extends State<DiagnosisTemplatesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DiagnosisTemplateListCubit>().loadTemplates();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DiagnosisTemplateListCubit>().loadMore();
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
    return BlocBuilder<DiagnosisTemplateListCubit, DiagnosisTemplateListState>(
      builder: (context, state) {
        final totalCount =
            state is DiagnosisTemplateListLoaded ? state.total : 0;
        final selectedFilter = state is DiagnosisTemplateListLoaded
            ? state.selectedFilter
            : DiagnosisTemplateFilterChip.all;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: DiagnosisTemplateListAppBar(totalCount: totalCount),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: context.primaryColor,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: Text('diagnosis_template.actions.add_new'.tr()),
            onPressed: () => DiagnosisTemplateFormSheet.show(
              context,
              cubit: context.read<DiagnosisTemplateListCubit>(),
            ),
          ),
          body: Column(
            children: [
              DiagnosisTemplateSearchBar(
                controller: _searchController,
                onChanged: (val) => context
                    .read<DiagnosisTemplateListCubit>()
                    .onSearchChanged(val),
                onClear: () => context
                    .read<DiagnosisTemplateListCubit>()
                    .loadTemplates(search: ''),
              ),
              const SizedBox(height: AppSpacing.xs),
              DiagnosisTemplateQuickChips(
                selected: selectedFilter,
                onSelected: (chip) =>
                    context.read<DiagnosisTemplateListCubit>().setFilter(chip),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DiagnosisTemplateListState state) {
    return switch (state) {
      DiagnosisTemplateListLoading() => const DiagnosisTemplateShimmer(),
      DiagnosisTemplateListError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () =>
              context.read<DiagnosisTemplateListCubit>().loadTemplates(),
        ),
      DiagnosisTemplateListEmpty(:final searchQuery) =>
        DiagnosisTemplateEmpty(
          searchQuery: searchQuery,
          onAction: () {
            if (searchQuery != null && searchQuery.isNotEmpty) {
              _searchController.clear();
              context.read<DiagnosisTemplateListCubit>().loadTemplates(search: '');
            } else {
              DiagnosisTemplateFormSheet.show(
                context,
                cubit: context.read<DiagnosisTemplateListCubit>(),
              );
            }
          },
        ),
      DiagnosisTemplateListLoaded(
        :final filteredItems,
        :final isFetchingMore,
      ) =>
        filteredItems.isEmpty
            ? DiagnosisTemplateEmpty(
                searchQuery: _searchController.text,
                onAction: () => context
                    .read<DiagnosisTemplateListCubit>()
                    .setFilter(DiagnosisTemplateFilterChip.all),
              )
            : RefreshIndicator(
                color: context.primaryColor,
                onRefresh: () =>
                    context.read<DiagnosisTemplateListCubit>().loadTemplates(),
                child: ListView.separated(
                  controller: _scrollController,
                  padding: AppSpacing.pagePadding,
                  itemCount: filteredItems.length + (isFetchingMore ? 1 : 0),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    if (index == filteredItems.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: AppShimmer(
                          child: AppShimmerBox(
                            width: double.infinity,
                            height: 60,
                            borderRadius: AppRadius.cardRadius,
                          ),
                        ),
                      );
                    }
                    final item = filteredItems[index];
                    return DiagnosisTemplateCard(
                      template: item,
                      onEdit: () => DiagnosisTemplateFormSheet.show(
                        context,
                        template: item,
                        cubit: context.read<DiagnosisTemplateListCubit>(),
                      ),
                      onDuplicate: () => _handleDuplicate(item),
                      onDelete: () => _handleDelete(item),
                    );
                  },
                ),
              ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _handleDuplicate(DiagnosisTemplateEntity item) async {
    final cubit = context.read<DiagnosisTemplateListCubit>();
    final suffix = 'diagnosis_template.copy_suffix'.tr();
    final res = await cubit.duplicateTemplate(item, suffix);
    if (!mounted) return;
    res.fold(
      (f) => AppSnackBar.showError(context, f.message),
      (_) => AppSnackBar.showSuccess(
        context,
        'diagnosis_template.duplicated_success'.tr(),
      ),
    );
  }

  Future<void> _handleDelete(DiagnosisTemplateEntity item) async {
    final confirmed = await DiagnosisTemplateDeleteDialog.show(
      context,
      title: item.title,
    );
    if (confirmed == true && mounted) {
      final cubit = context.read<DiagnosisTemplateListCubit>();
      final deleted = await cubit.deleteTemplate(item.id);
      if (deleted && mounted) {
        AppSnackBar.showSuccess(
          context,
          'diagnosis_template.deleted_success'.tr(),
        );
      }
    }
  }
}
