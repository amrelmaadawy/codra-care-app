import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';

class FollowUpFilterSheet extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final void Function(String? startDate, String? endDate) onApply;
  final VoidCallback onClear;

  const FollowUpFilterSheet({
    super.key,
    this.startDate,
    this.endDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<FollowUpFilterSheet> createState() => _FollowUpFilterSheetState();
}

class _FollowUpFilterSheetState extends State<FollowUpFilterSheet> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    if (widget.startDate != null) {
      _start = DateTime.tryParse(widget.startDate!);
    }
    if (widget.endDate != null) {
      _end = DateTime.tryParse(widget.endDate!);
    }
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: _start != null && _end != null
          ? DateTimeRange(start: _start!, end: _end!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _start = picked.start;
        _end = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final hasDates = _start != null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'reception_follow_ups.filter_title'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  Navigator.pop(context);
                },
                child: Text('reception_follow_ups.reset_filters'.tr()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'reception_follow_ups.date_range'.tr(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textMutedColor,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            onTap: _pickDateRange,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: context.surfaceVariantColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: context.dividerColor),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      hasDates
                          ? '${dateFormat.format(_start!)} → ${dateFormat.format(_end ?? _start!)}'
                          : 'reception_follow_ups.select_dates'.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: hasDates ? context.textColor : context.textMutedColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () {
              final startStr = _start != null ? dateFormat.format(_start!) : null;
              final endStr = _end != null ? dateFormat.format(_end!) : null;
              widget.onApply(startStr, endStr);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: context.onPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            child: Text('common.apply'.tr()),
          ),
        ],
      ),
    );
  }
}
