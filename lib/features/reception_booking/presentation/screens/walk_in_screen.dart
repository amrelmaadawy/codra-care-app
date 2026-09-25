import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_di.dart';
import '../cubits/walk_in_cubit.dart';
import '../views/walk_in_view.dart';

class WalkInScreen extends StatelessWidget {
  const WalkInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WalkInCubit>()..init(),
      child: const WalkInView(),
    );
  }
}
