import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/add_leave_day_use_case.dart';
import '../../domain/use_cases/check_appointments_conflict_use_case.dart';
import '../../domain/use_cases/delete_leave_day_use_case.dart';
import '../../domain/use_cases/get_leave_days_summary_use_case.dart';
import 'leave_days_state.dart';

class LeaveDaysCubit extends Cubit<LeaveDaysState> {
  final GetLeaveDaysSummaryUseCase getSummaryUseCase;
  final AddLeaveDayUseCase addLeaveDayUseCase;
  final DeleteLeaveDayUseCase deleteLeaveDayUseCase;
  final CheckAppointmentsConflictUseCase checkConflictUseCase;

  LeaveDaysCubit({
    required this.getSummaryUseCase,
    required this.addLeaveDayUseCase,
    required this.deleteLeaveDayUseCase,
    required this.checkConflictUseCase,
  }) : super(const LeaveDaysInitial());

  Future<void> loadSummary({bool showLoading = true}) async {
    if (showLoading || state is! LeaveDaysLoaded) {
      emit(const LeaveDaysLoading());
    }

    final result = await getSummaryUseCase();
    result.fold(
      (failure) => emit(LeaveDaysError(failure)),
      (summary) {
        final focused = state is LeaveDaysLoaded
            ? (state as LeaveDaysLoaded).focusedDay
            : DateTime.now();
        emit(LeaveDaysLoaded(
          summary: summary,
          focusedDay: focused,
        ));
      },
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (state is LeaveDaysLoaded) {
      final current = state as LeaveDaysLoaded;
      emit(current.copyWith(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
      ));
    }
  }

  void onPageChanged(DateTime focusedDay) {
    if (state is LeaveDaysLoaded) {
      final current = state as LeaveDaysLoaded;
      emit(current.copyWith(focusedDay: focusedDay));
    }
  }

  Future<int> checkAppointmentsConflict({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    final result = await checkConflictUseCase(
      date: date,
      startDate: startDate,
      endDate: endDate,
    );
    return result.fold((_) => 0, (count) => count);
  }

  Future<String?> addLeave({
    String? leaveDate,
    String? startDate,
    String? endDate,
    String? reason,
  }) async {
    if (state is! LeaveDaysLoaded) return 'State not loaded';
    final current = state as LeaveDaysLoaded;
    emit(current.copyWith(isActionLoading: true));

    final result = await addLeaveDayUseCase(
      leaveDate: leaveDate,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );

    return result.fold(
      (failure) {
        emit(current.copyWith(isActionLoading: false));
        return failure.message;
      },
      (newSummary) {
        emit(current.copyWith(
          summary: newSummary,
          isActionLoading: false,
          clearSelectedDay: true,
        ));
        return null;
      },
    );
  }

  Future<bool> deleteLeaveById(int id) async {
    if (state is! LeaveDaysLoaded) return false;
    final current = state as LeaveDaysLoaded;
    emit(current.copyWith(isActionLoading: true));

    final result = await deleteLeaveDayUseCase.callById(id);

    return result.fold(
      (failure) {
        emit(current.copyWith(isActionLoading: false));
        return false;
      },
      (newSummary) {
        emit(current.copyWith(
          summary: newSummary,
          isActionLoading: false,
          clearSelectedDay: true,
        ));
        return true;
      },
    );
  }

  Future<bool> deleteLeaveByDate(String date) async {
    if (state is! LeaveDaysLoaded) return false;
    final current = state as LeaveDaysLoaded;
    emit(current.copyWith(isActionLoading: true));

    final result = await deleteLeaveDayUseCase.callByDate(date);

    return result.fold(
      (failure) {
        emit(current.copyWith(isActionLoading: false));
        return false;
      },
      (newSummary) {
        emit(current.copyWith(
          summary: newSummary,
          isActionLoading: false,
          clearSelectedDay: true,
        ));
        return true;
      },
    );
  }
}
