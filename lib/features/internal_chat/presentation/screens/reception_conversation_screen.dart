import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../cubits/reception_conversation/reception_conversation_cubit.dart';
import '../views/reception_conversation_view.dart';

class ReceptionConversationScreen extends StatelessWidget {
  final int chatId;

  const ReceptionConversationScreen({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ReceptionConversationCubit>(param1: chatId)
        ..loadInitial()
        ..startPolling(),
      child: const ReceptionConversationView(),
    );
  }
}
