import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PrescriptionSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String? hintText;

  const PrescriptionSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    this.hintText,
  });

  @override
  State<PrescriptionSearchBar> createState() => _PrescriptionSearchBarState();
}

class _PrescriptionSearchBarState extends State<PrescriptionSearchBar> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() => _isFocused = _focusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused
                ? context.primaryColor
                : (isDark
                    ? context.dividerColor.withValues(alpha: 0.3)
                    : const Color(0xFFE2E8F0)),
            width: _isFocused ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? context.primaryColor.withValues(alpha: 0.12)
                  : (isDark ? Colors.black : const Color(0xFF0F172A))
                      .withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: _isFocused ? 12 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          cursorColor: context.primaryColor,
          style: AppTypography.bodyMedium.copyWith(
            color: context.textPrimaryColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'prescription.search_hint'.tr(),
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor.withValues(alpha: 0.65),
              fontSize: 13.5,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _isFocused
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : context.primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: context.primaryColor,
                  size: 19,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 54,
              minHeight: 44,
            ),
            suffixIcon: hasText
                ? IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.textMutedColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: context.textMutedColor,
                        size: 14,
                      ),
                    ),
                    onPressed: () {
                      widget.controller.clear();
                      widget.onClear();
                      setState(() {});
                    },
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: 13,
            ),
          ),
          onChanged: (val) {
            widget.onChanged(val);
            setState(() {});
          },
        ),
      ),
    );
  }
}
