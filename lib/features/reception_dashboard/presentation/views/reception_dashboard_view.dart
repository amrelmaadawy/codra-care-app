import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/reception_dashboard_cubit.dart';
import '../cubits/reception_dashboard_state.dart';
import '../widgets/reception_dashboard_app_bar.dart';
import '../widgets/reception_dashboard_content.dart';
import '../widgets/reception_dashboard_shimmer.dart';

class ReceptionDashboardView extends StatefulWidget {
  const ReceptionDashboardView({super.key});

  @override
  State<ReceptionDashboardView> createState() => _ReceptionDashboardViewState();
}

class _ReceptionDashboardViewState extends State<ReceptionDashboardView>
    with WidgetsBindingObserver {
  bool _isPullRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    final cubit = context.read<ReceptionDashboardCubit>();
    if (lifecycleState == AppLifecycleState.resumed) {
      cubit.resumePolling();
    } else if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive) {
      cubit.pausePolling();
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isPullRefreshing = true);
    await context.read<ReceptionDashboardCubit>().refresh();
    if (mounted) {
      setState(() => _isPullRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceptionDashboardCubit, ReceptionDashboardState>(
      listenWhen: (previous, current) =>
          current is ReceptionDashboardLoaded &&
          current.refreshWarning != null &&
          (previous is! ReceptionDashboardLoaded ||
              previous.refreshWarning != current.refreshWarning),
      listener: (context, state) {
        if (state is ReceptionDashboardLoaded && state.refreshWarning != null) {
          AppSnackBar.showWarning(context, state.refreshWarning!);
        }
      },
      builder: (context, state) {
        final lastUpdated = state is ReceptionDashboardLoaded
            ? state.data.generatedAt
            : null;

        return Scaffold(
          appBar: ReceptionDashboardAppBar(
            lastUpdated: lastUpdated,
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReceptionDashboardState state) {
    return switch (state) {
      ReceptionDashboardInitial() ||
      ReceptionDashboardLoading() => const ReceptionDashboardShimmer(),
      ReceptionDashboardError(:final failure) => AppErrorWidget(
        failure: failure,
        onRetry: () => context.read<ReceptionDashboardCubit>().retry(),
      ),
      ReceptionDashboardLoaded() => _buildLoadedContent(context, state),
    };
  }

  Widget _buildLoadedContent(
    BuildContext context,
    ReceptionDashboardLoaded state,
  ) {
    final cubit = context.read<ReceptionDashboardCubit>();

    return Column(
      children: [
        if (_isPullRefreshing)
          const AppShimmer(
            child: AppShimmerBox(
              width: double.infinity,
              height: 4,
              borderRadius: BorderRadius.zero,
            ),
          ),
        Expanded(
          child: RefreshIndicator.noSpinner(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.pagePadding,
              child: ReceptionDashboardContent(
                state: state,
                cubit: cubit,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
