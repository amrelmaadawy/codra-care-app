import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubit/examination_cubit.dart';
import '../views/examination_view.dart';

class ExaminationScreen extends StatelessWidget {
  final int visitId;

  const ExaminationScreen({
    super.key,
    required this.visitId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<ExaminationCubit>(param1: visitId)
        ..loadExamination(),
      child: const ExaminationView(),
    );
  }
}
