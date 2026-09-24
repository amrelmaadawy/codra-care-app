import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_chat_message_entity.dart';
import '../../domain/entities/message_delivery_status.dart';

class ChatMessageBubble extends StatelessWidget {
  final DoctorChatMessageEntity message;
  final VoidCallback? onRetry;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final isDoctor = message.isDoctor;

    final bubbleDecoration = isDoctor
        ? BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF007A7A), Color(0xFF005858)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF004A4A).withValues(alpha: 0.22),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          )
        : BoxDecoration(
            color: isDark ? AppColors.surfaceVariantDark : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
              bottomLeft: Radius.circular(4),
            ),
            border: Border.all(
              color: isDark
                  ? AppColors.dividerDark.withValues(alpha: 0.8)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          );

    final textColor = isDoctor
        ? Colors.white
        : (isDark ? AppColors.onBackgroundDark : const Color(0xFF1E293B));

    final metaColor = isDoctor
        ? Colors.white.withValues(alpha: 0.72)
        : (isDark ? AppColors.onSurfaceMutedDark : const Color(0xFF64748B));

    return Align(
      alignment: isDoctor ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 3,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 10,
          ),
          decoration: bubbleDecoration,
          child: Column(
            crossAxisAlignment:
                isDoctor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isDoctor) ...[
                Text(
                  message.senderName,
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 3),
              ],
              Text(
                message.message,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor,
                  fontSize: 14.5,
                  height: 1.38,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: AppTypography.caption.copyWith(
                      color: metaColor,
                      fontSize: 10.5,
                    ),
                  ),
                  if (isDoctor) ...[
                    const SizedBox(width: 4),
                    _buildReceiptIcon(metaColor),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptIcon(Color fallbackColor) {
    return switch (message.deliveryStatus) {
      MessageDeliveryStatus.sending => const SizedBox(
          width: 12,
          height: 12,
          child: Icon(AppIcons.clock, size: 11, color: Colors.white70),
        ),
      MessageDeliveryStatus.failed => GestureDetector(
          onTap: onRetry,
          child: const Icon(AppIcons.error, size: 14, color: AppColors.warningLight),
        ),
      MessageDeliveryStatus.sent => Icon(
          message.isRead ? AppIcons.doubleCheck : AppIcons.singleCheck,
          size: 15,
          color: message.isRead ? const Color(0xFF67E8F9) : fallbackColor,
        ),
    };
  }
}
