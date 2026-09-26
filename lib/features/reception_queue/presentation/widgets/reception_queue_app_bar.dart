import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionQueueAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isRefreshing;
  final DateTime? lastRefreshedAt;
  final ValueChanged<String?> onSearchChanged;
  final VoidCallback onRefresh;

  const ReceptionQueueAppBar({
    super.key,
    required this.isRefreshing,
    this.lastRefreshedAt,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ReceptionQueueAppBar> createState() => _ReceptionQueueAppBarState();
}

class _ReceptionQueueAppBarState extends State<ReceptionQueueAppBar> {
  bool _isSearchOpen = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSearchOpen) {
      return AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'reception_queue.search_hint'.tr(),
            border: InputBorder.none,
            hintStyle: TextStyle(color: context.textSecondaryColor, fontSize: 14),
          ),
          onChanged: (val) => widget.onSearchChanged(val.trim().isEmpty ? null : val),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_rounded),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged(null);
              setState(() => _isSearchOpen = false);
            },
          ),
        ],
      );
    }

    final formattedTime = widget.lastRefreshedAt != null
        ? DateFormat('HH:mm').format(widget.lastRefreshedAt!)
        : null;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'reception_queue.title'.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (formattedTime != null)
            Text(
              '${'reception_queue.last_updated'.tr()} $formattedTime',
              style: TextStyle(
                fontSize: 11,
                color: context.textSecondaryColor,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'reception_queue.search'.tr(),
          onPressed: () => setState(() => _isSearchOpen = true),
        ),
        IconButton(
          icon: widget.isRefreshing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Icon(Icons.sync_rounded, size: 20),
                )
              : const Icon(Icons.refresh_rounded),
          tooltip: 'reception_queue.refresh'.tr(),
          onPressed: widget.isRefreshing ? null : widget.onRefresh,
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}
