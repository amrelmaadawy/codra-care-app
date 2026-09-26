import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isDoctorActive;
  final bool canSend;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isDoctorActive = true,
    this.canSend = true,
    this.isSending = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateState);
  }

  void _updateState() {
    final text = _controller.text.trim();
    final isValid = text.isNotEmpty && text.length <= 2000;
    if (_canSubmit != isValid) {
      setState(() => _canSubmit = isValid);
    }
  }

  void _handleSend() {
    if (!_canSubmit || !widget.canSend || !widget.isDoctorActive) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSend(text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDoctorActive) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        color: context.warningColor.withValues(alpha: 0.12),
        child: Row(
          children: [
            Icon(AppIcons.warning, size: 18, color: context.warningColor),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'reception_chat.doctor_inactive_cannot_send'.tr(),
                style: AppTypography.caption.copyWith(
                  color: context.warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (!widget.canSend) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        border: Border(
          top: BorderSide(
            color: context.dividerColor.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: context.surfaceVariantColor.withValues(
                    alpha: isDark ? 0.4 : 0.6,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLength: 2000,
                  buildCounter: (_, {required currentLength, maxLength, required isFocused}) {
                    return currentLength > 1800
                        ? Text(
                            '$currentLength/$maxLength',
                            style: AppTypography.caption.copyWith(
                              fontSize: 10,
                              color: context.subtitleColor,
                            ),
                          )
                        : null;
                  },
                  style: AppTypography.bodyMedium.copyWith(
                    color: context.textColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'reception_chat.type_message'.tr(),
                    hintStyle: AppTypography.bodySmall.copyWith(
                      color: context.subtitleColor.withValues(alpha: 0.8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm + 2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Material(
              color: _canSubmit && !widget.isSending
                  ? context.primaryColor
                  : context.disabledColor.withValues(alpha: 0.2),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _canSubmit && !widget.isSending ? _handleSend : null,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: AppSizes.minTouchTarget,
                  height: AppSizes.minTouchTarget,
                  child: Center(
                    child: Icon(
                      AppIcons.send,
                      size: 20,
                      color: _canSubmit && !widget.isSending
                          ? AppColors.onPrimary
                          : context.disabledColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
