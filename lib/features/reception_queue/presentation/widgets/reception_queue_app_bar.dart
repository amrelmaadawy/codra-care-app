import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import 'queue_app_bar_icon_button.dart';

class ReceptionQueueAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isRefreshing;
  final DateTime? lastRefreshedAt;
  final int? totalPatients;
  final VoidCallback? onRefresh;
  final ValueChanged<String?> onSearchChanged;

  const ReceptionQueueAppBar({
    super.key,
    required this.isRefreshing,
    this.lastRefreshedAt,
    this.totalPatients,
    this.onRefresh,
    required this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

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
          : Container(height: 1, color: context.dividerColor.withValues(alpha: 0.2)),
    );

    if (_isSearchOpen) {
      return AppBar(
        toolbarHeight: 68,
        titleSpacing: AppSpacing.xs,
        leading: QueueAppBarIconButton(
          icon: Icons.arrow_back_rounded,
          margin: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
          onPressed: _closeSearch,
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: context.surfaceVariantColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.primaryColor.withValues(alpha: 0.35)),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'reception_queue.search_hint'.tr(),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search_rounded, size: 20, color: context.primaryColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged(null);
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
              hintStyle: TextStyle(color: context.textSecondaryColor, fontSize: 13),
            ),
            onChanged: (val) {
              setState(() {});
              widget.onSearchChanged(val.trim().isEmpty ? null : val);
            },
          ),
        ),
        bottom: bottomProgressBar,
      );
    }

    final formattedTime = widget.lastRefreshedAt != null
        ? DateFormat('HH:mm').format(widget.lastRefreshedAt!)
        : null;
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      toolbarHeight: 68,
      titleSpacing: canPop ? AppSpacing.xs : AppSpacing.md,
      leading: canPop
          ? QueueAppBarIconButton(
              icon: Icons.arrow_back_rounded,
              margin: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'reception_queue.title'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: context.textColor,
                  letterSpacing: -0.3,
                ),
              ),
              if (widget.totalPatients != null && widget.totalPatients! > 0)
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: context.primaryColor.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    '${widget.totalPatients}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.primaryColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.emerald.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                  child: SizedBox(width: 6, height: 6),
                ),
                const SizedBox(width: 4),
                Text(
                  formattedTime != null
                      ? '${'reception_queue.live_status'.tr()} • ${'reception_queue.last_updated'.tr()} $formattedTime'
                      : 'reception_queue.live_status'.tr(),
                  style: const TextStyle(fontSize: 10, color: AppColors.emeraldDark, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        QueueAppBarIconButton(
          icon: Icons.search_rounded,
          tooltip: 'reception_queue.search'.tr(),
          margin: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
          onPressed: () => setState(() => _isSearchOpen = true),
        ),
        if (widget.onRefresh != null)
          QueueAppBarIconButton(
            icon: Icons.refresh_rounded,
            tooltip: 'reception_queue.refresh'.tr(),
            margin: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            onPressed: widget.onRefresh,
          ),
      ],
      bottom: bottomProgressBar,
    );
  }
}
