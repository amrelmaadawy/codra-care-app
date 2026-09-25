import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../domain/entities/doctor_notification_entity.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/doctor_notifications_app_bar.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_shimmer_loading.dart';

class DoctorNotificationsView extends StatelessWidget {
  const DoctorNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final hasNotifications =
            state is NotificationsLoaded && state.notifications.isNotEmpty;
        final unreadCount = state is NotificationsLoaded ? state.totalUnread : 0;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.backgroundDark : const Color(0xFFF0F4F8),
          appBar: DoctorNotificationsAppBar(
            unreadCount: unreadCount,
            hasNotifications: hasNotifications,
            onMarkAllRead: () {
              HapticFeedback.lightImpact();
              context.read<NotificationsCubit>().dismissAll();
            },
          ),
          body: _buildBody(context, state),
        );
      },
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
