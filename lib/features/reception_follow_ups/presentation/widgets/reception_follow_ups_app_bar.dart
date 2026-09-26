import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class ReceptionFollowUpsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int totalCount;
  final bool isRefreshing;

  const ReceptionFollowUpsAppBar({
    super.key,
    required this.totalCount,
    this.isRefreshing = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: AppSpacing.xs,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        tooltip: 'common.cancel'.tr(),
        onPressed: () => context.pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'reception_follow_ups.title'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: context.textColor,
                  letterSpacing: -0.2,
                ),
              ),
              if (totalCount > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$totalCount',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'reception_follow_ups.subtitle'.tr(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: context.textMutedColor,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: isRefreshing
            ? LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
              )
            : const SizedBox(height: 2),
      ),
    );
  }
}
