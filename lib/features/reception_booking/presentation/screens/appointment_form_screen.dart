import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../cubits/appointment_form_cubit.dart';
import '../views/appointment_form_view.dart';

class AppointmentFormScreen extends StatelessWidget {
  final String? initialDate;

  const AppointmentFormScreen({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AppointmentFormCubit>()..init(initialDate: initialDate),
      child: const AppointmentFormView(),
    );
  }
}
