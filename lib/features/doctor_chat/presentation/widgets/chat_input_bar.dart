import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'chat_character_counter.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final bool isSending;

  const ChatInputBar({
    super.key,
    required this.onSend,
    this.isSending = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late final TextEditingController _controller;
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    setState(() {
      _charCount = _controller.text.length;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSending) return;

    if (int.tryParse(text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('chat.error_numbers_only'.tr()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final canSend = _charCount > 0 && !widget.isSending && _charCount <= 2000;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark
                ? AppColors.dividerDark.withValues(alpha: 0.7)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatCharacterCounter(currentLength: _charCount),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 8,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceVariantDark
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? AppColors.dividerDark.withValues(alpha: 0.8)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: 4,
                        minLines: 1,
                        maxLength: 2000,
                        buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.onBackgroundDark : const Color(0xFF1E293B),
                          fontSize: 14.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'chat.type_message'.tr(),
                          hintStyle: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.onSurfaceMutedDark
                                : const Color(0xFF94A3B8),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: canSend ? _submit : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: canSend
                            ? const LinearGradient(
                                colors: [Color(0xFF007A7A), Color(0xFF005858)],
                              )
                            : null,
                        color: canSend
                            ? null
                            : (isDark ? AppColors.surfaceVariantDark : const Color(0xFFE2E8F0)),
                        boxShadow: canSend
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF006B6B).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Icon(
                          AppIcons.send,
                          size: 20,
                          color: canSend
                              ? Colors.white
                              : (isDark ? AppColors.onSurfaceMutedDark : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ),
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
