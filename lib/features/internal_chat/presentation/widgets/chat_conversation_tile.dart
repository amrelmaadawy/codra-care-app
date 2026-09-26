import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import 'chat_doctor_avatar.dart';
import 'chat_message_date_utils.dart';

class ChatConversationTile extends StatelessWidget {
  final ChatConversationEntity conversation;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatConversationTile({
    super.key,
    required this.conversation,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = conversation.doctor;
    final lastMsg = conversation.lastMessage;
    final timeStr = ChatMessageDateUtils.formatTime(lastMsg?.createdAt);

    return Material(
      color: isSelected
          ? context.primaryColor.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSizes.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: isSelected
                ? Border.all(
                    color: context.primaryColor.withValues(alpha: 0.25),
                  )
                : null,
          ),
          child: Row(
            children: [
              ChatDoctorAvatar(name: doctor.name, isActive: doctor.isActive),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: AppTypography.titleSmall.copyWith(
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: context.textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!doctor.isActive) ...[
                          const SizedBox(width: AppSpacing.xs),
                          _buildInactiveBadge(context),
                        ],
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          timeStr,
                          style: AppTypography.caption.copyWith(
                            color: conversation.unreadCount > 0
                                ? context.primaryColor
                                : context.subtitleColor,
                            fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMsg?.preview ??
                                (doctor.specialization ??
                                    'reception_chat.tap_to_start'.tr()),
                            style: AppTypography.bodySmall.copyWith(
                              color: conversation.unreadCount > 0
                                  ? context.textColor
                                  : context.subtitleColor,
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.unreadCount > 0)
                          _buildUnreadBadge(context),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: context.warningColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        'reception_chat.inactive'.tr(),
        style: AppTypography.caption.copyWith(
          color: context.warningColor,
          fontWeight: FontWeight.w600,
          fontSize: 9.5,
        ),
      ),
    );
  }

  Widget _buildUnreadBadge(BuildContext context) {
    final count = conversation.unreadCount;
    final text = count > 99 ? '99+' : '$count';

    return Container(
      margin: const EdgeInsetsDirectional.only(start: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: context.primaryColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 10.5,
        ),
      ),
    );
  }
}
