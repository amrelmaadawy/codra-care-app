import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../cubits/appointments_cubit.dart';
import '../views/appointments_view.dart';

class AppointmentsScreen extends StatelessWidget {
  final String? initialDate;
  final bool isCheckInMode;

  const AppointmentsScreen({
    super.key,
    this.initialDate,
    this.isCheckInMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<AppointmentsCubit>();
        cubit.loadInitial(initialDate: initialDate).then((_) {
          if (isCheckInMode) {
            cubit.setCheckInMode(true);
          }
        });
        return cubit;
      },
      child: const AppointmentsView(),
    );
  }
}
