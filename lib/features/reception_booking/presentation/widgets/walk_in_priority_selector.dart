import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class WalkInPrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;

  const WalkInPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = [
      _PriorityConfig(
        key: 'normal',
        titleKey: 'reception_booking.priority_normal',
        descKey: 'reception_booking.priority_normal_desc',
        icon: Icons.access_time_filled_rounded,
        accentColor: context.primaryColor,
      ),
      const _PriorityConfig(
        key: 'urgent',
        titleKey: 'reception_booking.priority_urgent',
        descKey: 'reception_booking.priority_urgent_desc',
        icon: Icons.bolt_rounded,
        accentColor: AppColors.error,
      ),
      const _PriorityConfig(
        key: 'vip',
        titleKey: 'reception_booking.priority_vip',
        descKey: 'reception_booking.priority_vip_desc',
        icon: Icons.workspace_premium_rounded,
        accentColor: Color(0xFF8B5CF6), // Royal Purple
      ),
    ];

    return Row(
      children: priorities.map((p) {
        final isSelected = selectedPriority == p.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildPriorityCard(context, p, isSelected),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriorityCard(
    BuildContext context,
    _PriorityConfig config,
    bool isSelected,
  ) {
    final border = isSelected ? config.accentColor : context.dividerColor.withValues(alpha: 0.6);
    final bg = isSelected
        ? config.accentColor.withValues(alpha: 0.08)
        : context.surfaceVariantColor.withValues(alpha: 0.4);

    return InkWell(
      onTap: () => onPriorityChanged(config.key),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: border, width: isSelected ? 2 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: config.accentColor.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? config.accentColor
                    : config.accentColor.withValues(alpha: 0.12),
              ),
              child: Icon(
                config.icon,
                size: 20,
                color: isSelected ? Colors.white : config.accentColor,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              config.titleKey.tr(),
              style: AppTypography.labelMedium.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? config.accentColor : context.textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              config.descKey.tr(),
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                color: isSelected
                    ? config.accentColor.withValues(alpha: 0.9)
                    : context.textMutedColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriorityConfig {
  final String key;
  final String titleKey;
  final String descKey;
  final IconData icon;
  final Color accentColor;

  const _PriorityConfig({
    required this.key,
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.accentColor,
  });
}
