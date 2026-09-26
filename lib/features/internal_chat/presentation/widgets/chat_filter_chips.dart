import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatFilterChips extends StatelessWidget {
  final String statusFilter;
  final ValueChanged<String> onSelected;

  const ChatFilterChips({
    super.key,
    required this.statusFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'key': 'all', 'label': 'reception_chat.all_doctors'.tr()},
      {'key': 'active', 'label': 'reception_chat.active_doctors'.tr()},
      {'key': 'inactive', 'label': 'reception_chat.inactive_doctors'.tr()},
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          final item = filters[index];
          final isSelected = statusFilter == item['key'];

          return ChoiceChip(
            label: Text(
              item['label']!,
              style: AppTypography.caption.copyWith(
                color: isSelected ? context.primaryColor : context.subtitleColor,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(item['key']!),
            selectedColor: context.primaryColor.withValues(alpha: 0.12),
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: isSelected
                  ? context.primaryColor
                  : context.dividerColor.withValues(alpha: 0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          );
        },
      ),
    );
  }
}
