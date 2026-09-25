import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../cubits/appointments_cubit.dart';
import '../views/appointments_view.dart';

class AppointmentsScreen extends StatelessWidget {
  final String? initialDate;

  const AppointmentsScreen({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AppointmentsCubit>()..loadInitial(initialDate: initialDate),
      child: const AppointmentsView(),
    );
  }
}
