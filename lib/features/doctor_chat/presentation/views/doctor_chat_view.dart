import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_date_divider.dart';
import '../widgets/chat_empty_state.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_shimmer_loading.dart';
import '../widgets/chat_unread_divider.dart';
import '../widgets/doctor_chat_app_bar.dart';

class DoctorChatView extends StatefulWidget {
  const DoctorChatView({super.key});

  @override
  State<DoctorChatView> createState() => _DoctorChatViewState();
}

class _DoctorChatViewState extends State<DoctorChatView> {
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatLoaded) {
          if (state.messages.length > _lastMessageCount) {
            _scrollToBottom();
          }
          _lastMessageCount = state.messages.length;

          if (state.sendError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sendError!.tr()),
                backgroundColor: AppColors.error,
              ),
            );
            context.read<ChatCubit>().clearSendError();
          }
        }
      },
      builder: (context, state) {
        final isActive = state is ChatLoaded ? state.chat.doctorIsActive : true;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
          appBar: DoctorChatAppBar(isActive: isActive, isDark: isDark),
          body: Column(
            children: [
              Expanded(child: _buildBody(context, state)),
              ChatInputBar(
                isSending: state is ChatLoaded && state.isSending,
                onSend: (text) => context.read<ChatCubit>().sendMessage(text),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ChatState state) {
    return switch (state) {
      ChatInitial() || ChatLoading() => const ChatShimmerLoading(),
      ChatEmpty() => const ChatEmptyState(),
      ChatError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () => context.read<ChatCubit>().initChat(),
        ),
      ChatLoaded(:final messages, :final firstUnreadMessageId) =>
        _buildMessageList(context, messages, firstUnreadMessageId),
    };
  }

  Widget _buildMessageList(
    BuildContext context,
    List<DoctorChatMessageEntity> messages,
    int? firstUnreadId,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showDate = index == 0 || messages[index - 1].date != message.date;
        final showUnread = firstUnreadId != null && message.id == firstUnreadId;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDate) ChatDateDivider(dateString: message.date),
            if (showUnread) const ChatUnreadDivider(),
            ChatMessageBubble(
              message: message,
              onRetry: () => context.read<ChatCubit>().retrySendMessage(message),
            ),
          ],
        );
      },
    );
  }
}
