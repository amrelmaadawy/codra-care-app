import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/chat_doctor_participant_entity.dart';
import '../cubits/reception_conversation/reception_conversation_cubit.dart';
import '../cubits/reception_conversation/reception_conversation_state.dart';
import '../widgets/chat_date_divider.dart';
import '../widgets/chat_empty_view.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_message_date_utils.dart';
import '../widgets/chat_shimmer.dart';
import '../widgets/chat_unread_divider.dart';
import '../widgets/conversation_header.dart';

class ReceptionConversationView extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const ReceptionConversationView({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  State<ReceptionConversationView> createState() =>
      _ReceptionConversationViewState();
}

class _ReceptionConversationViewState extends State<ReceptionConversationView> {
  final ScrollController _scrollController = ScrollController();
  int _prevMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100) {
      context.read<ReceptionConversationCubit>().loadOlderMessages();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceptionConversationCubit, ReceptionConversationState>(
      listener: (context, state) {
        if (state.messages.length > _prevMessageCount) {
          _scrollToBottom();
        }
        _prevMessageCount = state.messages.length;
      },
      builder: (context, state) {
        final doctor = state.conversation?.doctor ??
            const ChatDoctorParticipantEntity(id: 0, name: '');

        return Scaffold(
          backgroundColor: context.surfaceColor,
          body: Column(
            children: [
              ConversationHeader(
                doctor: doctor,
                showBackButton: widget.showBackButton,
                onBack: widget.onBack,
              ),
              if (state.pollingWarning) _buildPollingWarning(context),
              Expanded(child: _buildBody(context, state)),
              ChatInputBar(
                isDoctorActive: doctor.isActive,
                canSend: state.conversation?.capabilities.canSend ?? true,
                isSending: state.isSending,
                onSend: (msg) =>
                    context.read<ReceptionConversationCubit>().sendMessage(msg),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPollingWarning(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.warningColor.withValues(alpha: 0.12),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      child: Text(
        'reception_chat.connection_warning'.tr(),
        style: AppTypography.caption.copyWith(color: context.warningColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildBody(BuildContext context, ReceptionConversationState state) {
    if (state.isLoading) return const ConversationShimmer();
    if (state.isError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'errors.unexpected'.tr(),
              style: AppTypography.bodyMedium.copyWith(color: context.errorColor),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () =>
                  context.read<ReceptionConversationCubit>().loadInitial(),
              child: Text('common.retry'.tr()),
            ),
          ],
        ),
      );
    }
    if (state.messages.isEmpty) {
      return ChatEmptyView(
        title: 'reception_chat.no_messages_yet'.tr(),
        subtitle: 'reception_chat.send_first_message'.tr(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: state.messages.length + (state.isLoadingOlder ? 1 : 0),
      itemBuilder: (context, index) {
        if (state.isLoadingOlder && index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: ConversationShimmer(count: 1),
          );
        }

        final msgIndex = state.isLoadingOlder ? index - 1 : index;
        final msg = state.messages[msgIndex];
        final showDate = ChatMessageDateUtils.shouldShowDate(state.messages, msgIndex);
        final showUnread = ChatMessageDateUtils.shouldShowUnread(state.messages, msgIndex);

        return Column(
          children: [
            if (showDate)
              ChatDateDivider(
                dateText: ChatMessageDateUtils.formatDate(msg.createdAt),
              ),
            if (showUnread) const ChatUnreadDivider(),
            ChatMessageBubble(
              message: msg,
              onRetry: () => context
                  .read<ReceptionConversationCubit>()
                  .retryFailedMessage(msg),
            ),
          ],
        );
      },
    );
  }
}
