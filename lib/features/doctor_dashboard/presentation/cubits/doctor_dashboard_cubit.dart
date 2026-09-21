import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_dashboard_use_case.dart';
import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final GetDoctorDashboardUseCase _getDoctorDashboardUseCase;

  DoctorDashboardCubit(this._getDoctorDashboardUseCase)
      : super(const DoctorDashboardInitial());

  @override
  void emit(DoctorDashboardState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> loadDashboard() async {
    emit(const DoctorDashboardLoading());

    final result = await _getDoctorDashboardUseCase();

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorDashboardError(failure)),
      (data) => emit(DoctorDashboardLoaded(data)),
    );
  }

  Future<void> refresh() async {
    final result = await _getDoctorDashboardUseCase();

    if (isClosed) return;
    result.fold(
      (failure) => emit(DoctorDashboardError(failure)),
      (data) => emit(DoctorDashboardLoaded(data)),
    );
  }
}
