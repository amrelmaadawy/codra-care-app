import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../cubit/leave_days_cubit.dart';
import 'date_picker_tile.dart';
import 'leave_conflict_dialog.dart';
import 'leave_type_selector.dart';

class AddLeaveDaySheet extends StatefulWidget {
  final LeaveDaysCubit cubit;
  final DateTime? initialDate;

  const AddLeaveDaySheet({super.key, required this.cubit, this.initialDate});

  static Future<void> show(
    BuildContext context, {
    required LeaveDaysCubit cubit,
    DateTime? initialDate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => AddLeaveDaySheet(cubit: cubit, initialDate: initialDate),
    );
  }

  @override
  State<AddLeaveDaySheet> createState() => _AddLeaveDaySheetState();
}

class _AddLeaveDaySheetState extends State<AddLeaveDaySheet> {
  bool _isRange = false;
  late DateTime _singleDate;
  late DateTime _startDate;
  late DateTime _endDate;
  final _reasonController = TextEditingController();
  bool _isSubmitting = false;
  final _fmt = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _singleDate = widget.initialDate != null && !widget.initialDate!.isBefore(today)
        ? widget.initialDate!
        : now;
    _startDate = _singleDate;
    _endDate = _singleDate.add(const Duration(days: 1));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart, bool isSingle = false}) async {
    final now = DateTime.now();
    final initial = isSingle ? _singleDate : (isStart ? _startDate : _endDate);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(now) ? now : initial,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null) return;
    setState(() {
      if (isSingle) {
        _singleDate = picked;
      } else if (isStart) {
        _startDate = picked;
        if (_endDate.isBefore(picked)) _endDate = picked.add(const Duration(days: 1));
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _onSubmit() async {
    setState(() => _isSubmitting = true);
    final dateStr = _isRange ? null : _fmt.format(_singleDate);
    final startStr = _isRange ? _fmt.format(_startDate) : null;
    final endStr = _isRange ? _fmt.format(_endDate) : null;

    final conflicts = await widget.cubit.checkAppointmentsConflict(
      date: dateStr,
      startDate: startStr,
      endDate: endStr,
    );

    if (!mounted) return;
    if (conflicts > 0) {
      final confirm = await showLeaveConflictDialog(context, conflicts);
      if (confirm != true) {
        setState(() => _isSubmitting = false);
        return;
      }
    }

    final error = await widget.cubit.addLeave(
      leaveDate: dateStr,
      startDate: startStr,
      endDate: endStr,
      reason: _reasonController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (error == null) {
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(context, 'leave_days.create_success'.tr());
    } else {
      AppSnackBar.showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'leave_days.add_leave'.tr(),
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          LeaveTypeSelector(
            isRange: _isRange,
            onTypeChanged: (val) => setState(() => _isRange = val),
          ),
          const SizedBox(height: AppSpacing.md),
          if (!_isRange)
            DatePickerTile(label: 'leave_days.select_date'.tr(), value: _fmt.format(_singleDate), onTap: () => _pickDate(isStart: false, isSingle: true))
          else
            Row(
              children: [
                Expanded(child: DatePickerTile(label: 'leave_days.start_date'.tr(), value: _fmt.format(_startDate), onTap: () => _pickDate(isStart: true))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: DatePickerTile(label: 'leave_days.end_date'.tr(), value: _fmt.format(_endDate), onTap: () => _pickDate(isStart: false))),
              ],
            ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _reasonController,
            labelKey: 'leave_days.reason',
            hintKey: 'leave_days.reason_hint',
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            labelKey: 'common.save',
            isLoading: _isSubmitting,
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }
}
