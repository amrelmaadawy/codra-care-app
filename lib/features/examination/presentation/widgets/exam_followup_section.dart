import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'exam_draft_indicator.dart';
import 'exam_followup_day_chips.dart';
import 'exam_section_card.dart';

class ExamFollowupSection extends StatefulWidget {
  final int? initialDays;
  final String? initialNotes;
  final bool isSaving;
  final bool isSaved;
  final void Function(int? days, String? notes) onChanged;

  const ExamFollowupSection({
    super.key,
    this.initialDays,
    this.initialNotes,
    required this.isSaving,
    required this.isSaved,
    required this.onChanged,
  });

  @override
  State<ExamFollowupSection> createState() => _ExamFollowupSectionState();
}

class _ExamFollowupSectionState extends State<ExamFollowupSection> {
  late final TextEditingController _notesController;
  int? _days;

  @override
  void initState() {
    super.initState();
    _days = widget.initialDays;
    _notesController = TextEditingController(text: widget.initialNotes ?? '');
  }

  @override
  void didUpdateWidget(covariant ExamFollowupSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDays != oldWidget.initialDays) {
      _days = widget.initialDays;
    }
    if (widget.initialNotes != oldWidget.initialNotes) {
      _notesController.text = widget.initialNotes ?? '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged(_days, _notesController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ExamSectionCard(
      title: 'examination.followup'.tr(),
      icon: Icons.calendar_month_outlined,
      trailing: ExamDraftIndicator(
        isSaving: widget.isSaving,
        isSaved: widget.isSaved,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'examination.followup_days'.tr(),
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ExamFollowupDayChips(
            selectedDays: _days,
            onSelected: (days) {
              setState(() => _days = days);
              _notifyChange();
            },
          ),
          if (_days != null && _days! > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildDatePreview(),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            'examination.followup_notes'.tr(),
            style: AppTypography.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.onBackgroundDark : AppColors.onBackgroundLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: _notesController,
            onChanged: (_) => _notifyChange(),
            minLines: 2,
            maxLines: 4,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: 'examination.followup_notes_hint'.tr(),
              hintStyle: AppTypography.bodySmall.copyWith(
                color: isDark ? AppColors.onSurfaceMutedDark : AppColors.onSurfaceMutedLight,
              ),
              prefixIcon: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
              filled: true,
              fillColor: isDark ? AppColors.surfaceVariantDark : const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: isDark ? AppColors.dividerDark : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePreview() {
    final targetDate = DateTime.now().add(Duration(days: _days!));
    final formatted = DateFormat('yyyy-MM-dd (EEEE)', context.locale.languageCode).format(targetDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.event_available_rounded, size: 16, color: Color(0xFF16A34A)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'examination.followup_date_preview'.tr(args: [formatted]),
            style: AppTypography.caption.copyWith(
              color: const Color(0xFF15803D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
