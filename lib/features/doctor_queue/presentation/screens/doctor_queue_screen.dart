import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubit/doctor_queue_cubit.dart';
import '../views/doctor_queue_view.dart';

class DoctorQueueScreen extends StatelessWidget {
  const DoctorQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<DoctorQueueCubit>()..loadQueue(),
      child: const DoctorQueueView(),
    );
  }
}
