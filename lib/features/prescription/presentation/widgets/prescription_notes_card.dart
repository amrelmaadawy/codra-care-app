import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class PrescriptionNotesCard extends StatefulWidget {
  final String notes;
  final List<String> quickNotes;
  final ValueChanged<String> onChanged;

  const PrescriptionNotesCard({
    super.key,
    required this.notes,
    this.quickNotes = const [],
    required this.onChanged,
  });

  @override
  State<PrescriptionNotesCard> createState() => _PrescriptionNotesCardState();
}

class _PrescriptionNotesCardState extends State<PrescriptionNotesCard> {
  late final TextEditingController _controller;

  static const _defaultQuickNotes = [
    'الراحة التامة لمدة يومين',
    'شرب سوائل دافئة بكثرة',
    'المتابعة بعد أسبوع',
    'تجنب الأطعمة الحارة والدهنية',
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(PrescriptionNotesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notes != oldWidget.notes && widget.notes != _controller.text) {
      _controller.text = widget.notes;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onChipTapped(String item) {
    final current = _controller.text;
    String updated;
    if (current.contains(item)) {
      final lines = current.split('\n').where((l) => l.trim() != item.trim()).toList();
      updated = lines.join('\n').trim();
    } else {
      updated = current.trim().isEmpty ? item : '$current\n$item';
    }
    _controller.text = updated;
    _controller.selection = TextSelection.collapsed(offset: updated.length);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chips = widget.quickNotes.isNotEmpty ? widget.quickNotes : _defaultQuickNotes;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: context.dividerColor.withValues(alpha: 0.4)),
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.emerald.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_note_rounded, color: AppColors.emerald, size: 18),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'prescription.notes'.tr(),
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _controller,
            maxLines: 3,
            style: AppTypography.bodyMedium.copyWith(color: context.textPrimaryColor),
            decoration: InputDecoration(
              hintText: 'prescription.notes_hint'.tr(),
              hintStyle: AppTypography.bodySmall.copyWith(
                color: context.textSecondaryColor.withValues(alpha: 0.7),
              ),
              filled: true,
              fillColor: isDark ? context.surfaceColor : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(AppSpacing.sm + 4),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: AppColors.emerald, width: 1.4),
              ),
            ),
            onChanged: widget.onChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) => _buildChip(chips[index], isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String item, bool isDark) {
    final isAdded = _controller.text.contains(item);
    return InkWell(
      onTap: () => _onChipTapped(item),
      borderRadius: BorderRadius.circular(15),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isAdded
              ? AppColors.emerald.withValues(alpha: 0.1)
              : (isDark ? context.surfaceColor : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isAdded
                ? AppColors.emerald.withValues(alpha: 0.4)
                : context.dividerColor.withValues(alpha: 0.4),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isAdded) ...[
              const Icon(Icons.check_rounded, size: 12, color: AppColors.emerald),
              const SizedBox(width: 4),
            ],
            Text(
              item,
              style: AppTypography.labelSmall.copyWith(
                fontSize: 11,
                fontWeight: isAdded ? FontWeight.w600 : FontWeight.normal,
                color: isAdded ? AppColors.emerald : context.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
