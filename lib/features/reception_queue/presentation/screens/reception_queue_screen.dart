import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubit/reception_queue_cubit.dart';
import '../views/reception_queue_view.dart';

class ReceptionQueueScreen extends StatelessWidget {
  const ReceptionQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ReceptionQueueCubit>()
        ..loadQueue()
        ..startAutoPolling(),
      child: const ReceptionQueueView(),
    );
  }
}
