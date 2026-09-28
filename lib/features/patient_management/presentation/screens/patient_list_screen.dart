import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubits/patient_list_cubit.dart';
import '../cubits/patient_list_state.dart';
import '../views/patient_list_view.dart';
import '../widgets/patient_list_app_bar.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientListCubit, PatientListState>(
      buildWhen: (prev, curr) {
        final prevCount = prev is PatientListSuccess ? prev.total : null;
        final currCount = curr is PatientListSuccess ? curr.total : null;
        return prevCount != currCount;
      },
      builder: (context, state) {
        final totalCount = state is PatientListSuccess ? state.total : null;

        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: PatientListAppBar(
            totalCount: totalCount,
            onRefresh: () => context.read<PatientListCubit>().refresh(),
          ),
          body: const SafeArea(child: PatientListView()),
        );
      },
    );
  }
}
