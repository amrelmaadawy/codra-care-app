import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/message_delivery_status.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final VoidCallback? onRetry;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
  });

  String _formatTime(String rawIso) {
    if (rawIso.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawIso).toLocal();
      return DateFormat.jm().format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = message.isDoctor;
    final timeStr = _formatTime(message.createdAt);

    return Align(
      alignment: isDoctor
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDoctor
              ? context.surfaceVariantColor.withValues(
                  alpha: context.isDarkMode ? 0.5 : 0.7,
                )
              : context.primaryColor.withValues(
                  alpha: context.isDarkMode ? 0.22 : 0.12,
                ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isDoctor ? AppRadius.xs : AppRadius.lg),
            topRight: Radius.circular(isDoctor ? AppRadius.lg : AppRadius.xs),
            bottomLeft: const Radius.circular(AppRadius.lg),
            bottomRight: const Radius.circular(AppRadius.lg),
          ),
          border: Border.all(
            color: isDoctor
                ? context.dividerColor.withValues(alpha: 0.3)
                : context.primaryColor.withValues(alpha: 0.25),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isDoctor ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (!isDoctor && message.sender.name != null) ...[
              Text(
                message.sender.name!,
                style: AppTypography.caption.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              message.body,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textColor,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: AppTypography.caption.copyWith(
                    color: context.subtitleColor.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
                if (!isDoctor) ...[
                  const SizedBox(width: 4),
                  _buildDeliveryStatus(context),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryStatus(BuildContext context) {
    switch (message.deliveryStatus) {
      case MessageDeliveryStatus.sending:
        return SizedBox(
          width: 10,
          height: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.subtitleColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
        );
      case MessageDeliveryStatus.failed:
        return InkWell(
          onTap: onRetry,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(AppIcons.refresh, size: 12, color: context.errorColor),
              const SizedBox(width: 2),
              Text(
                'common.retry'.tr(),
                style: AppTypography.caption.copyWith(
                  color: context.errorColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      case MessageDeliveryStatus.read:
        return Icon(
          AppIcons.doubleCheck,
          size: 14,
          color: context.primaryColor,
        );
      case MessageDeliveryStatus.sent:
        return Icon(
          message.isRead ? AppIcons.doubleCheck : AppIcons.singleCheck,
          size: 14,
          color: message.isRead
              ? context.primaryColor
              : context.subtitleColor.withValues(alpha: 0.7),
        );
    }
  }
}
