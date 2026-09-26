import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionQueueAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isRefreshing;
  final DateTime? lastRefreshedAt;
  final ValueChanged<String?> onSearchChanged;

  const ReceptionQueueAppBar({
    super.key,
    required this.isRefreshing,
    this.lastRefreshedAt,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);

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

  void _closeSearch() {
    _searchController.clear();
    widget.onSearchChanged(null);
    setState(() => _isSearchOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final bottomProgressBar = PreferredSize(
      preferredSize: const Size.fromHeight(2),
      child: widget.isRefreshing
          ? LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
            )
          : const SizedBox(height: 2),
    );

    if (_isSearchOpen) {
      return AppBar(
        titleSpacing: AppSpacing.sm,
        title: Container(
          height: 42,
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'reception_queue.search_hint'.tr(),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 20,
                color: context.textSecondaryColor,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: 10,
              ),
              hintStyle: TextStyle(
                color: context.textSecondaryColor,
                fontSize: 13,
              ),
            ),
            onChanged: (val) => widget.onSearchChanged(val.trim().isEmpty ? null : val),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: 'common.cancel'.tr(),
            onPressed: _closeSearch,
          ),
        ],
        bottom: bottomProgressBar,
      );
    }

    final formattedTime = widget.lastRefreshedAt != null
        ? DateFormat('HH:mm').format(widget.lastRefreshedAt!)
        : null;

    return AppBar(
      titleSpacing: AppSpacing.md,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'reception_queue.title'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                formattedTime != null
                    ? '${'reception_queue.live_status'.tr()} • ${'reception_queue.last_updated'.tr()} $formattedTime'
                    : 'reception_queue.live_status'.tr(),
                style: TextStyle(
                  fontSize: 11,
                  color: context.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          tooltip: 'reception_queue.search'.tr(),
          onPressed: () => setState(() => _isSearchOpen = true),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      bottom: bottomProgressBar,
    );
  }
}
