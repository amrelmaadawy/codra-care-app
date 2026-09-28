import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PatientSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const PatientSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<PatientSearchBar> createState() => _PatientSearchBarState();
}

class _PatientSearchBarState extends State<PatientSearchBar> {
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
    final query = widget.controller.text;
    final hasText = query.isNotEmpty;
    final showMinCharsHint = query.trim().length == 1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 52,
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: _isFocused ? context.primaryColor : context.dividerColor,
                width: _isFocused ? 1.5 : 1.0,
              ),
              boxShadow: context.cardShadow,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              cursorColor: context.primaryColor,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textColor,
              ),
              decoration: InputDecoration(
                hintText: 'patients.search_hint'.tr(),
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: context.textMutedColor,
                ),
                prefixIcon: Icon(
                  AppIcons.search,
                  color: _isFocused
                      ? context.primaryColor
                      : context.textMutedColor,
                  size: 20,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                suffixIcon: hasText
                    ? IconButton(
                        icon: const Icon(AppIcons.close, size: 18),
                        color: context.textMutedColor,
                        onPressed: () {
                          widget.controller.clear();
                          widget.onClear();
                          setState(() {});
                        },
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 14,
                ),
              ),
              onChanged: (val) {
                widget.onChanged(val);
                setState(() {});
              },
            ),
          ),
          if (showMinCharsHint) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(AppIcons.info, size: 14, color: AppColors.warning),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'patients.search_min_chars'.tr(),
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.warning,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
