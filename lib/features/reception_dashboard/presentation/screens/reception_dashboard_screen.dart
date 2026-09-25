import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubits/reception_dashboard_cubit.dart';
import '../views/reception_dashboard_view.dart';

class ReceptionDashboardScreen extends StatelessWidget {
  const ReceptionDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ReceptionDashboardCubit>()..load(),
      child: const ReceptionDashboardView(),
    );
  }
}
