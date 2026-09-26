import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../cubits/reception_chat_list/reception_chat_list_cubit.dart';
import '../cubits/reception_chat_list/reception_chat_list_state.dart';
import '../cubits/reception_conversation/reception_conversation_cubit.dart';
import '../views/reception_chat_list_view.dart';
import '../views/reception_conversation_view.dart';
import '../widgets/chat_empty_view.dart';

class ReceptionInternalChatScreen extends StatelessWidget {
  const ReceptionInternalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ReceptionChatListCubit>()
        ..loadChats()
        ..startPolling(),
      child: const _ReceptionInternalChatContent(),
    );
  }
}

class _ReceptionInternalChatContent extends StatelessWidget {
  const _ReceptionInternalChatContent();

  void _onChatSelected(BuildContext context, ChatConversationEntity chat) {
    final isMobile = ResponsiveUtils.isMobile(context);
    if (isMobile) {
      context.push(AppRoutes.receptionInternalChatDetailPath(chat.id));
    } else {
      context.read<ReceptionChatListCubit>().selectChat(chat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: context.surfaceColor,
      appBar: isMobile
          ? AppBar(
              title: Text('shell.internal_chat'.tr()),
              elevation: 0,
              backgroundColor: context.surfaceColor,
            )
          : null,
      body: isMobile ? _buildMobile(context) : _buildTablet(context),
    );
  }

  Widget _buildMobile(BuildContext context) {
    return ReceptionChatListView(
      onChatSelected: (chat) => _onChatSelected(context, chat),
    );
  }

  Widget _buildTablet(BuildContext context) {
    return BlocBuilder<ReceptionChatListCubit, ReceptionChatListState>(
      buildWhen: (prev, curr) => prev.selectedChatId != curr.selectedChatId,
      builder: (context, state) {
        return Row(
          children: [
            SizedBox(
              width: 340,
              child: ReceptionChatListView(
                selectedChatId: state.selectedChatId,
                onChatSelected: (chat) => _onChatSelected(context, chat),
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: context.dividerColor.withValues(alpha: 0.6),
            ),
            Expanded(
              child: state.selectedChatId != null
                  ? KeyedSubtree(
                      key: ValueKey(state.selectedChatId),
                      child: BlocProvider(
                        create: (_) => GetIt.I<ReceptionConversationCubit>(
                          param1: state.selectedChatId,
                        )
                          ..loadInitial()
                          ..startPolling(),
                        child: const ReceptionConversationView(
                          showBackButton: false,
                        ),
                      ),
                    )
                  : ChatEmptyView(
                      title: 'reception_chat.select_conversation'.tr(),
                      subtitle:
                          'reception_chat.select_conversation_hint'.tr(),
                    ),
            ),
          ],
        );
      },
    );
  }
}
