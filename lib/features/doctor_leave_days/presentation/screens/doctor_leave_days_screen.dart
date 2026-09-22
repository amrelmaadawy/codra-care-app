import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubit/leave_days_cubit.dart';
import '../cubit/leave_days_state.dart';
import '../widgets/add_leave_day_sheet.dart';
import '../widgets/doctor_leave_days_app_bar.dart';
import '../widgets/leave_day_delete_dialog.dart';
import '../widgets/leave_day_details_sheet.dart';
import '../widgets/leave_day_shimmer.dart';
import '../widgets/leave_day_stats_row.dart';
import '../widgets/leave_day_upcoming_section.dart';
import '../widgets/leave_days_calendar.dart';

class DoctorLeaveDaysScreen extends StatefulWidget {
  const DoctorLeaveDaysScreen({super.key});

  @override
  State<DoctorLeaveDaysScreen> createState() => _DoctorLeaveDaysScreenState();
}

class _DoctorLeaveDaysScreenState extends State<DoctorLeaveDaysScreen> {
  final _dateFmt = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    context.read<LeaveDaysCubit>().loadSummary();
  }

  String _formatDate(DateTime? date, String fallback) {
    if (date == null) return fallback;
    return DateFormat('d MMMM yyyy', context.locale.languageCode).format(date);
  }

  void _onDaySelected(
    DateTime selectedDay,
    DateTime focusedDay,
    LeaveDaysLoaded state,
  ) {
    final cubit = context.read<LeaveDaysCubit>();
    cubit.onDaySelected(selectedDay, focusedDay);

    final dateKey = _dateFmt.format(selectedDay);
    if (state.summary.leaveDatesSet.contains(dateKey)) {
      final leave = state.summary.upcomingLeaves
          .where((l) => l.leaveDate == dateKey)
          .firstOrNull;

      final display = _formatDate(leave?.parsedDate ?? selectedDay, dateKey);

      LeaveDayDetailsSheet.show(
        context,
        leave: leave,
        dateStr: dateKey,
        onDelete: () => _confirmDeleteByDate(dateKey, display),
      );
    } else {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      if (!selectedDay.isBefore(today)) {
        AddLeaveDaySheet.show(
          context,
          cubit: cubit,
          initialDate: selectedDay,
        );
      }
    }
  }

  Future<bool?> _showDeleteConfirmation(String displayDate) {
    return LeaveDayDeleteDialog.show(context, dateString: displayDate);
  }

  Future<void> _confirmDeleteById(int id, String displayDate) async {
    final confirmed = await _showDeleteConfirmation(displayDate);
    if (confirmed == true && mounted) {
      final ok = await context.read<LeaveDaysCubit>().deleteLeaveById(id);
      if (ok && mounted) {
        AppSnackBar.showSuccess(context, 'leave_days.delete_success'.tr());
      }
    }
  }

  Future<void> _confirmDeleteByDate(String dateStr, String displayDate) async {
    final confirmed = await _showDeleteConfirmation(displayDate);
    if (confirmed == true && mounted) {
      final ok = await context.read<LeaveDaysCubit>().deleteLeaveByDate(dateStr);
      if (ok && mounted) {
        AppSnackBar.showSuccess(context, 'leave_days.delete_success'.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LeaveDaysCubit>();

    return Scaffold(
      appBar: DoctorLeaveDaysAppBar(
        upcomingCount: context.select<LeaveDaysCubit, int>(
          (c) => c.state is LeaveDaysLoaded
              ? (c.state as LeaveDaysLoaded).summary.upcomingCount
              : 0,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AddLeaveDaySheet.show(context, cubit: cubit),
        icon: const Icon(AppIcons.add),
        label: Text('leave_days.add_leave'.tr()),
      ),
      body: BlocBuilder<LeaveDaysCubit, LeaveDaysState>(
        builder: (context, state) {
          if (state is LeaveDaysLoading || state is LeaveDaysInitial) {
            return const LeaveDayShimmer();
          }

          if (state is LeaveDaysError) {
            return AppErrorWidget(
              failure: state.failure,
              onRetry: () => cubit.loadSummary(),
            );
          }

          if (state is LeaveDaysLoaded) {
            return RefreshIndicator(
              onRefresh: () => cubit.loadSummary(showLoading: false),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        LeaveDayStatsRow(
                          totalCount: state.summary.totalCount,
                          thisMonthCount: state.summary.thisMonthCount,
                          upcomingCount: state.summary.upcomingCount,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        LeaveDaysCalendar(
                          focusedDay: state.focusedDay,
                          selectedDay: state.selectedDay,
                          leaveDates: state.summary.leaveDatesSet,
                          onDaySelected: (sel, foc) =>
                              _onDaySelected(sel, foc, state),
                          onPageChanged: cubit.onPageChanged,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        LeaveDayUpcomingSection(
                          upcomingLeaves: state.summary.upcomingLeaves,
                          onDelete: (leave) => _confirmDeleteById(
                            leave.id,
                            _formatDate(leave.parsedDate, leave.formattedDate ?? leave.leaveDate),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl * 2),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
