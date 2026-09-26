import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../cubits/reception_follow_ups_cubit.dart';
import '../views/reception_follow_ups_view.dart';

class ReceptionFollowUpsScreen extends StatelessWidget {
  const ReceptionFollowUpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ReceptionFollowUpsCubit>()..init(),
      child: const ReceptionFollowUpsView(),
    );
  }
}
