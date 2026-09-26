import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class FollowUpSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const FollowUpSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  State<FollowUpSearchBar> createState() => _FollowUpSearchBarState();
}

class _FollowUpSearchBarState extends State<FollowUpSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: context.dividerColor.withValues(alpha: 0.6),
                ),
              ),
              child: TextField(
                controller: _controller,
                onChanged: widget.onSearchChanged,
                textInputAction: TextInputAction.search,
                style: TextStyle(
                  fontSize: 14,
                  color: context.textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'reception_follow_ups.search_hint'.tr(),
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: context.textMutedColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: context.textMutedColor,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _controller.clear();
                            widget.onSearchChanged('');
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
            ),
          ),
          if (widget.onFilterTap != null) ...[
            const SizedBox(width: AppSpacing.sm),
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.md),
              onTap: widget.onFilterTap,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.hasActiveFilters
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : context.surfaceColor,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: widget.hasActiveFilters
                        ? context.primaryColor
                        : context.dividerColor.withValues(alpha: 0.6),
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  size: 20,
                  color: widget.hasActiveFilters
                      ? context.primaryColor
                      : context.textMutedColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
