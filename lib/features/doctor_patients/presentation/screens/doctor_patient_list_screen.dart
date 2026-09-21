import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../cubit/patient_list_cubit.dart';
import '../cubit/patient_list_state.dart';
import '../widgets/patient_card.dart';
import '../widgets/patient_list_app_bar.dart';
import '../widgets/patient_list_empty_state.dart';
import '../widgets/patient_list_shimmer.dart';
import '../widgets/patient_search_bar.dart';

class DoctorPatientListScreen extends StatefulWidget {
  const DoctorPatientListScreen({super.key});

  @override
  State<DoctorPatientListScreen> createState() =>
      _DoctorPatientListScreenState();
}

class _DoctorPatientListScreenState extends State<DoctorPatientListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PatientListCubit>().loadPatients();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PatientListCubit>().loadMore();
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
    return BlocBuilder<PatientListCubit, PatientListState>(
      builder: (context, state) {
        final totalCount = state is PatientListLoaded
            ? (state.totalPatientsStat ?? state.total)
            : 0;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PatientListAppBar(totalCount: totalCount),
          body: Column(
            children: [
              PatientSearchBar(
                controller: _searchController,
                onChanged: (val) =>
                    context.read<PatientListCubit>().onSearchChanged(val),
                onClear: () =>
                    context.read<PatientListCubit>().loadPatients(search: ''),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, PatientListState state) {
    return switch (state) {
      PatientListLoading() => const PatientListShimmer(),
      PatientListError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () => context.read<PatientListCubit>().loadPatients(),
        ),
      PatientListEmpty(:final searchQuery) => PatientListEmptyState(
          isSearch: searchQuery != null && searchQuery.isNotEmpty,
        ),
      PatientListLoaded(:final items, :final isFetchingMore) =>
        RefreshIndicator(
          color: context.primaryColor,
          onRefresh: () => context.read<PatientListCubit>().loadPatients(),
          child: ListView.separated(
            controller: _scrollController,
            padding: AppSpacing.pagePadding,
            itemCount: items.length + (isFetchingMore ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              if (index == items.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: AppShimmer(
                      child: AppShimmerBox(
                        width: 140,
                        height: 24,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                );
              }
              final patient = items[index];
              return PatientCard(
                patient: patient,
                onTap: () => context.push('/patients/${patient.id}'),
              );
            },
          ),
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
