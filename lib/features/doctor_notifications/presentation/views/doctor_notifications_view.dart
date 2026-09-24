import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../domain/entities/doctor_notification_entity.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_shimmer_loading.dart';
import '../widgets/notifications_unread_badge.dart';

class DoctorNotificationsView extends StatelessWidget {
  const DoctorNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF0F4F8),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(context, state, isDark, innerBoxIsScrolled),
            ],
            body: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    NotificationsState state,
    bool isDark,
    bool innerBoxIsScrolled,
  ) {
    final hasNotifications = state is NotificationsLoaded && state.notifications.isNotEmpty;
    final unreadCount = state is NotificationsLoaded ? state.totalUnread : 0;

    return SliverAppBar(
      expandedHeight: 110,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: innerBoxIsScrolled ? 2 : 0,
      shadowColor: context.dividerColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textColor, size: 20),
        onPressed: () => context.pop(),
      ),
      actions: [
        if (hasNotifications)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.read<NotificationsCubit>().dismissAll();
              },
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: Text('notifications.mark_all'.tr()),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            kToolbarHeight,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'notifications.title'.tr(),
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w800,
                      color: context.textColor,
                    ),
                  ),
                  if (unreadCount > 0) ...[
                    const SizedBox(width: AppSpacing.sm),
                    NotificationsUnreadBadge(count: unreadCount),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'notifications.subtitle'.tr(),
                style: AppTypography.bodySmall.copyWith(
                  color: context.textMutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    return switch (state) {
      NotificationsInitial() || NotificationsLoading() =>
        const NotificationsShimmerLoading(),
      NotificationsEmpty() => RefreshIndicator(
          onRefresh: () => context.read<NotificationsCubit>().refresh(),
          color: AppColors.primary,
          child: const SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: 400,
              child: NotificationsEmptyState(),
            ),
          ),
        ),
      NotificationsError(:final failure) => AppErrorWidget(
          failure: failure,
          onRetry: () => context.read<NotificationsCubit>().loadNotifications(),
        ),
      NotificationsLoaded(:final notifications) =>
        _buildList(context, notifications),
    };
  }

  Widget _buildList(
    BuildContext context,
    List<DoctorNotificationEntity> notifications,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<NotificationsCubit>().refresh(),
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xxxl,
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
            key: ValueKey('${notification.type.toApiString()}_${notification.id}'),
            notification: notification,
            onDismiss: () {
              HapticFeedback.mediumImpact();
              context.read<NotificationsCubit>().dismissNotification(notification);
            },
            onTap: notification.type == NotificationType.chatMessage
                ? () => context.push(AppRoutes.doctorChat)
                : null,
          );
        },
      ),
    );
  }
}
