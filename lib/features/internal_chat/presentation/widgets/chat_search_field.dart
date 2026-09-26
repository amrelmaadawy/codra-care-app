import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatSearchField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String? initialValue;

  const ChatSearchField({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<ChatSearchField> createState() => _ChatSearchFieldState();
}

class _ChatSearchFieldState extends State<ChatSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: context.surfaceVariantColor.withValues(
          alpha: context.isDarkMode ? 0.35 : 0.6,
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        style: AppTypography.bodyMedium.copyWith(
          color: context.textColor,
          fontSize: 13.5,
        ),
        decoration: InputDecoration(
          hintText: 'reception_chat.search_placeholder'.tr(),
          hintStyle: AppTypography.bodySmall.copyWith(
            color: context.subtitleColor.withValues(alpha: 0.7),
          ),
          prefixIcon: Icon(
            AppIcons.search,
            size: 20,
            color: context.subtitleColor,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(AppIcons.close, size: 18),
                  color: context.subtitleColor,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
        ),
      ),
    );
  }
}
