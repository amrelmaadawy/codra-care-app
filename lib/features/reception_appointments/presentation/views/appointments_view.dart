import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../domain/entities/appointment_entity.dart';
import '../cubits/appointments_cubit.dart';
import '../cubits/appointments_state.dart';
import '../widgets/appointment_cancel_dialog.dart';
import '../widgets/appointment_check_in_sheet.dart';
import '../widgets/appointment_filter_sheet.dart';
import '../widgets/appointment_list_shimmer.dart';
import '../widgets/appointments_app_bar.dart';
import '../widgets/appointments_calendar_bar.dart';
import '../widgets/appointments_list_content.dart';

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AppointmentsCubit>().loadMore();
    }
  }

  void _showCancelDialog(AppointmentEntity appt) {
    final cubit = context.read<AppointmentsCubit>();
    AppointmentCancelDialog.show(
      context: context,
      patientName: appt.patient.name,
      isCancelling: false,
      onConfirm: (reason) {
        Navigator.of(context).pop();
        cubit.cancelAppointment(appointmentId: appt.id, reason: reason);
      },
    );
  }

  void _showCheckInSheet(AppointmentEntity appt) {
    final cubit = context.read<AppointmentsCubit>();
    AppointmentCheckInSheet.show(
      context: context,
      appointment: appt,
      isSubmitting: false,
      onConfirm: (priority) {
        Navigator.of(context).pop();
        cubit.checkInAppointment(appointmentId: appt.id, priority: priority);
      },
    );
  }

  void _showFilters(AppointmentsLoaded state) {
    final cubit = context.read<AppointmentsCubit>();
    AppointmentFilterSheet.show(
      context: context,
      selectedStatus: state.filters.status,
      onStatusChanged: (status) => cubit.setStatusFilter(status),
      onClearFilters: () => cubit.clearFilters(),
    );
  }

  Future<void> _openNewAppointment() async {
    final result = await context.push(AppRoutes.appointmentNew);
    if (result == true && mounted) {
      context.read<AppointmentsCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AppointmentsCubit, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentsLoaded) {
          if (state.cancelSuccessMessage != null) {
            AppSnackBar.showSuccess(context, state.cancelSuccessMessage!.tr());
          }
          if (state.cancelError != null) AppSnackBar.showError(context, state.cancelError!);
          if (state.checkInSuccessMessage != null) {
            AppSnackBar.showSuccess(context, state.checkInSuccessMessage!.tr());
          }
          if (state.checkInError != null) AppSnackBar.showError(context, state.checkInError!);
          if (state.refreshWarning != null) AppSnackBar.showWarning(context, state.refreshWarning!);
        }
      },
      builder: (context, state) {
        final cubit = context.read<AppointmentsCubit>();
        final hasActiveFilter =
            state is AppointmentsLoaded && state.filters.status != null;

        return Scaffold(
          appBar: AppointmentsAppBar(
            hasActiveFilter: hasActiveFilter,
            onFilterPressed: () {
              if (state is AppointmentsLoaded) _showFilters(state);
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openNewAppointment,
            icon: const Icon(Icons.add),
            label: Text('reception_appointments.new_appointment'.tr()),
          ),
          body: _buildBody(context, state, cubit, isDark),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppointmentsState state, AppointmentsCubit cubit, bool isDark) {
    if (state is AppointmentsLoading) return const AppointmentListShimmer();

    if (state is AppointmentsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => cubit.loadInitial(),
              child: Text('reception_appointments.retry'.tr()),
            ),
          ],
        ),
      );
    }

    if (state is AppointmentsLoaded) {
      return Column(
        children: [
          AppointmentsCalendarBar(
            selectedDate: state.selectedDate,
            currentMonth: state.currentMonth,
            calendarDays: state.calendarDays,
            isExpanded: state.isMonthExpanded,
            onDateSelected: (date) => cubit.selectDate(date),
            onMonthChanged: (month) => cubit.changeMonth(month),
            onToggleExpand: () => cubit.toggleMonthExpanded(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => cubit.refresh(),
              child: AppointmentsListContent(
                items: state.items,
                isPaginating: state.isPaginating,
                scrollController: _scrollController,
                onCancelAppointment: _showCancelDialog,
                onCheckInAppointment: _showCheckInSheet,
                checkingInId: state.checkingInId,
                onNewAppointment: _openNewAppointment,
              ),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
