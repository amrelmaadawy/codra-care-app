import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_prescription_detail_use_case.dart';
import 'prescription_detail_state.dart';

class PrescriptionDetailCubit extends Cubit<PrescriptionDetailState> {
  final GetPrescriptionDetailUseCase getPrescriptionDetailUseCase;

  PrescriptionDetailCubit({
    required this.getPrescriptionDetailUseCase,
  }) : super(const PrescriptionDetailInitial());

  Future<void> loadPrescription(int id) async {
    emit(const PrescriptionDetailLoading());
    final result = await getPrescriptionDetailUseCase(id);
    result.fold(
      (failure) => emit(PrescriptionDetailError(failure)),
      (entity) => emit(PrescriptionDetailLoaded(entity)),
    );
  }
}
