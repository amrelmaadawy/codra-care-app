import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final DoctorNotificationEntity notification;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDismiss,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final typeStyle = _NotificationTypeStyle.from(notification.type);

    return Dismissible(
      key: ValueKey('${notification.type.toApiString()}_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(context),
      onDismissed: (_) => onDismiss(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: AppRadius.cardRadius,
            border: Border(
              right: BorderSide(
                color: typeStyle.accentColor,
                width: 4,
              ),
            ),
            boxShadow: context.cardShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildIcon(typeStyle),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildContent(context)),
                const SizedBox(width: AppSpacing.xs),
                _buildDismissButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(_NotificationTypeStyle style) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: style.accentColor.withValues(alpha: 0.12),
        borderRadius: AppRadius.cardRadius,
      ),
      child: Icon(
        style.iconData,
        color: style.accentColor,
        size: 22,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w700,
            color: context.textColor,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          notification.subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: context.textMutedColor,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 11,
              color: context.textMutedColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 3),
            Text(
              notification.meta,
              style: AppTypography.labelSmall.copyWith(
                color: context.textMutedColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDismissButton(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: context.dividerColor,
          borderRadius: AppRadius.circleRadius,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 14,
          color: context.textMutedColor,
        ),
      ),
    );
  }

  Widget _buildDismissBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.85),
        borderRadius: AppRadius.cardRadius,
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: const Icon(
        Icons.delete_sweep_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

/// Centralized visual configuration for each notification type
class _NotificationTypeStyle {
  final Color accentColor;
  final IconData iconData;

  const _NotificationTypeStyle({
    required this.accentColor,
    required this.iconData,
  });

  factory _NotificationTypeStyle.from(NotificationType type) => switch (type) {
        NotificationType.urgentCase  => const _NotificationTypeStyle(
            accentColor: AppColors.statusUrgent,
            iconData: Icons.warning_amber_rounded,
          ),
        NotificationType.newPatient  => const _NotificationTypeStyle(
            accentColor: AppColors.info,
            iconData: Icons.person_add_alt_1_rounded,
          ),
        NotificationType.chatMessage => const _NotificationTypeStyle(
            accentColor: AppColors.primary,
            iconData: Icons.chat_bubble_outline_rounded,
          ),
        NotificationType.doctorLeave => const _NotificationTypeStyle(
            accentColor: AppColors.accent,
            iconData: Icons.event_busy_rounded,
          ),
        NotificationType.unknown     => const _NotificationTypeStyle(
            accentColor: AppColors.onSurfaceMutedLight,
            iconData: Icons.notifications_none_rounded,
          ),
      };
}
