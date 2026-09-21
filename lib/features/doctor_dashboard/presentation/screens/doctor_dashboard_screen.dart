import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../cubits/doctor_dashboard_cubit.dart';
import '../cubits/doctor_dashboard_state.dart';
import '../views/doctor_dashboard_view.dart';
import '../widgets/doctor_dashboard_shimmer.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<DoctorDashboardCubit>()..loadDashboard(),
      child: const _DoctorDashboardBody(),
    );
  }
}

class _DoctorDashboardBody extends StatelessWidget {
  const _DoctorDashboardBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
      builder: (context, state) {
        return switch (state) {
          DoctorDashboardInitial() || DoctorDashboardLoading() => const DoctorDashboardShimmer(),
          DoctorDashboardError(:final failure) => Scaffold(
              body: AppErrorWidget(
                failure: failure,
                onRetry: () => context.read<DoctorDashboardCubit>().loadDashboard(),
              ),
            ),
          DoctorDashboardLoaded(:final data) => DoctorDashboardView(
              data: data,
              onRefresh: () => context.read<DoctorDashboardCubit>().refresh(),
            ),
        };
      },
    );
  }
}
