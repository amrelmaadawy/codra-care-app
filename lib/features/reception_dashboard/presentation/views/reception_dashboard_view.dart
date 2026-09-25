import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/reception_dashboard_cubit.dart';
import '../cubits/reception_dashboard_state.dart';
import '../widgets/active_queue_section.dart';
import '../widgets/appointments_today_grid.dart';
import '../widgets/quick_stats_section.dart';
import '../widgets/reception_dashboard_app_bar.dart';
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
            onRefresh: () => context.read<ReceptionDashboardCubit>().refresh(),
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
    final isMobile = ResponsiveUtils.isMobile(context);
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
              child: isMobile
                  ? _buildMobileLayout(state, cubit)
                  : _buildTabletLayout(state, cubit),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    ReceptionDashboardLoaded state,
    ReceptionDashboardCubit cubit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppointmentsTodayGrid(stats: state.data.appointmentsToday),
        const SizedBox(height: AppSpacing.lg),
        QuickStatsSection(
          totalPatientsToday: state.data.totalPatientsToday,
          pendingFollowUps: state.data.pendingFollowUpsCount,
        ),
        const SizedBox(height: AppSpacing.lg),
        ActiveQueueSection(
          queueItems: state.data.activeQueue,
          doctors: state.data.doctors,
          activeWaitingCount: state.data.activeWaitingCount,
          selectedDoctorId: state.selectedDoctorId,
          isQueueRefreshing: state.isQueueRefreshing,
          onDoctorSelected: cubit.selectDoctor,
        ),
      ],
    );
  }

  Widget _buildTabletLayout(
    ReceptionDashboardLoaded state,
    ReceptionDashboardCubit cubit,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppointmentsTodayGrid(stats: state.data.appointmentsToday),
              const SizedBox(height: AppSpacing.lg),
              QuickStatsSection(
                totalPatientsToday: state.data.totalPatientsToday,
                pendingFollowUps: state.data.pendingFollowUpsCount,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          flex: 6,
          child: ActiveQueueSection(
            queueItems: state.data.activeQueue,
            doctors: state.data.doctors,
            activeWaitingCount: state.data.activeWaitingCount,
            selectedDoctorId: state.selectedDoctorId,
            isQueueRefreshing: state.isQueueRefreshing,
            onDoctorSelected: cubit.selectDoctor,
          ),
        ),
      ],
    );
  }
}
