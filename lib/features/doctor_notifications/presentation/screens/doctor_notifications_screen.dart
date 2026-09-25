import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubit/notifications_cubit.dart';
import '../views/doctor_notifications_view.dart';

class DoctorNotificationsScreen extends StatelessWidget {
  const DoctorNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NotificationsCubit>()..loadNotifications(),
      child: const DoctorNotificationsView(),
    );
  }
}
