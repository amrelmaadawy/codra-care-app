import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_patient_detail_use_case.dart';
import 'patient_detail_state.dart';

class PatientDetailCubit extends Cubit<PatientDetailState> {
  final GetPatientDetailUseCase getPatientDetailUseCase;

  PatientDetailCubit({
    required this.getPatientDetailUseCase,
  }) : super(const PatientDetailInitial());

  Future<void> loadPatientDetail(int id) async {
    emit(const PatientDetailLoading());

    final result = await getPatientDetailUseCase(id);

    result.fold(
      (failure) => emit(PatientDetailError(failure)),
      (detail) => emit(PatientDetailLoaded(detail)),
    );
  }
}
