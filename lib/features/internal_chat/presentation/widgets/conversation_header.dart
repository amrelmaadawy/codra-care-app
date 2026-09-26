import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/chat_doctor_participant_entity.dart';

class ConversationHeader extends StatelessWidget implements PreferredSizeWidget {
  final ChatDoctorParticipantEntity doctor;
  final bool showBackButton;
  final VoidCallback? onBack;

  const ConversationHeader({
    super.key,
    required this.doctor,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(AppIcons.back, size: 22),
                color: context.textColor,
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: doctor.isActive
                    ? context.primaryColor.withValues(alpha: 0.12)
                    : context.disabledColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  doctor.name.isNotEmpty ? doctor.name.characters.first : '?',
                  style: AppTypography.titleMedium.copyWith(
                    color: doctor.isActive
                        ? context.primaryColor
                        : context.disabledColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          doctor.name,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: context.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!doctor.isActive) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
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
                        ),
                      ],
                    ],
                  ),
                  if (doctor.specialization != null)
                    Text(
                      doctor.specialization!,
                      style: AppTypography.caption.copyWith(
                        color: context.subtitleColor,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
