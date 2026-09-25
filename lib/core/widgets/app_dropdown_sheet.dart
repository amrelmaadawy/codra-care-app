import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';
import 'app_dropdown_header.dart';
import 'app_dropdown_tile.dart';

class AppDropdownSheet<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedItem;
  final String Function(T item) itemLabel;
  final String? Function(T item)? itemSubtitle;
  final Widget Function(T item)? itemLeading;
  final bool isSearchable;
  final String? searchHint;
  final ValueChanged<T> onSelected;

  const AppDropdownSheet({
    super.key,
    required this.title,
    required this.items,
    this.selectedItem,
    required this.itemLabel,
    this.itemSubtitle,
    this.itemLeading,
    this.isSearchable = true,
    this.searchHint,
    required this.onSelected,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    T? selectedItem,
    required String Function(T item) itemLabel,
    String? Function(T item)? itemSubtitle,
    Widget Function(T item)? itemLeading,
    bool isSearchable = true,
    String? searchHint,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      useSafeArea: true,
      builder: (ctx) => AppDropdownSheet<T>(
        title: title,
        items: items,
        selectedItem: selectedItem,
        itemLabel: itemLabel,
        itemSubtitle: itemSubtitle,
        itemLeading: itemLeading,
        isSearchable: isSearchable,
        searchHint: searchHint,
        onSelected: (val) => Navigator.of(ctx).pop(val),
      ),
    );
  }

  @override
  State<AppDropdownSheet<T>> createState() => _AppDropdownSheetState<T>();
}

class _AppDropdownSheetState<T> extends State<AppDropdownSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filteredItems = q.isEmpty
          ? widget.items
          : widget.items.where((item) {
              final label = widget.itemLabel(item).toLowerCase();
              final sub = widget.itemSubtitle?.call(item)?.toLowerCase() ?? '';
              return label.contains(q) || sub.contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final showSearch = widget.isSearchable && widget.items.length > 3;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.78),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDropdownHeader(
              title: widget.title,
              itemCount: widget.items.length,
              onClose: () => Navigator.of(context).pop(),
            ),
            if (showSearch)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 6),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? context.backgroundColor : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.dividerColor.withValues(alpha: 0.4)),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: AppTypography.bodyMedium.copyWith(color: context.textColor),
                    decoration: InputDecoration(
                      hintText: widget.searchHint ?? 'common.search_hint'.tr(),
                      hintStyle: AppTypography.bodySmall.copyWith(color: context.textMutedColor.withValues(alpha: 0.7)),
                      prefixIcon: Icon(Icons.search_rounded, color: context.primaryColor, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: _onSearch,
                  ),
                ),
              ),
            Divider(height: 1, thickness: 1, color: context.dividerColor.withValues(alpha: 0.35)),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 40, color: context.textMutedColor),
                          const SizedBox(height: 8),
                          Text('common.no_results'.tr(), style: AppTypography.bodyMedium.copyWith(color: context.textMutedColor)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
                      itemCount: _filteredItems.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return AppDropdownTile<T>(
                          item: item,
                          isSelected: widget.selectedItem == item,
                          label: widget.itemLabel(item),
                          subtitle: widget.itemSubtitle?.call(item),
                          leading: widget.itemLeading?.call(item),
                          onSelected: widget.onSelected,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
