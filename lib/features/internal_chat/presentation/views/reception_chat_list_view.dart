import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../widgets/chat_filter_chips.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../cubits/reception_chat_list/reception_chat_list_cubit.dart';
import '../cubits/reception_chat_list/reception_chat_list_state.dart';
import '../widgets/chat_conversation_tile.dart';
import '../widgets/chat_empty_view.dart';
import '../widgets/chat_search_field.dart';
import '../widgets/chat_shimmer.dart';

class ReceptionChatListView extends StatefulWidget {
  final ValueChanged<ChatConversationEntity> onChatSelected;
  final int? selectedChatId;

  const ReceptionChatListView({
    super.key,
    required this.onChatSelected,
    this.selectedChatId,
  });

  @override
  State<ReceptionChatListView> createState() => _ReceptionChatListViewState();
}

class _ReceptionChatListViewState extends State<ReceptionChatListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReceptionChatListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceptionChatListCubit, ReceptionChatListState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Column(
                children: [
                  ChatSearchField(
                    initialValue: state.searchQuery,
                    onChanged: (q) =>
                        context.read<ReceptionChatListCubit>().onSearchChanged(q),
                  ),
                  ChatFilterChips(
                    statusFilter: state.statusFilter,
                    onSelected: (key) => context
                        .read<ReceptionChatListCubit>()
                        .onStatusFilterChanged(key),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _buildBody(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ReceptionChatListState state) {
    if (state.isLoading) {
      return const ChatListShimmer();
    }

    if (state.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'errors.unexpected'.tr(),
                style: AppTypography.bodyMedium.copyWith(color: context.errorColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<ReceptionChatListCubit>().loadChats(isRefresh: true),
                icon: const Icon(AppIcons.refresh, size: 16),
                label: Text('common.retry'.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (state.isEmpty) {
      return ChatEmptyView(
        title: state.searchQuery.isNotEmpty
            ? 'reception_chat.no_search_results'.tr()
            : 'reception_chat.no_chats_found'.tr(),
        subtitle: state.searchQuery.isNotEmpty
            ? 'reception_chat.try_another_search'.tr()
            : 'reception_chat.chats_appear_here'.tr(),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      itemCount: state.chats.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => const SizedBox(height: 2),
      itemBuilder: (context, index) {
        if (index >= state.chats.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: ChatListShimmer(count: 1),
          );
        }

        final chat = state.chats[index];
        final isSelected = widget.selectedChatId == chat.id;

        return ChatConversationTile(
          conversation: chat,
          isSelected: isSelected,
          onTap: () => widget.onChatSelected(chat),
        );
      },
    );
  }
}
