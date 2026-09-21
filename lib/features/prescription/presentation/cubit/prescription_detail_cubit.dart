import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_prescription_detail_use_case.dart';
import '../../domain/use_cases/mark_printed_use_case.dart';
import 'prescription_detail_state.dart';

class PrescriptionDetailCubit extends Cubit<PrescriptionDetailState> {
  final GetPrescriptionDetailUseCase getPrescriptionDetailUseCase;
  final MarkPrintedUseCase markPrintedUseCase;

  PrescriptionDetailCubit({
    required this.getPrescriptionDetailUseCase,
    required this.markPrintedUseCase,
  }) : super(const PrescriptionDetailInitial());

  @override
  void emit(PrescriptionDetailState state) {
    if (!isClosed) {
      super.emit(state);
    }
  }

  Future<void> loadPrescription(int id) async {
    emit(const PrescriptionDetailLoading());
    final result = await getPrescriptionDetailUseCase(id);
    if (isClosed) return;
    result.fold(
      (failure) => emit(PrescriptionDetailError(failure)),
      (entity) => emit(PrescriptionDetailLoaded(entity)),
    );
  }

  Future<void> markPrinted(int id) async {
    final result = await markPrintedUseCase(id);
    if (isClosed) return;
    result.fold(
      (_) {},
      (_) {
        final current = state;
        if (current is PrescriptionDetailLoaded) {
          emit(PrescriptionDetailLoaded(
            current.prescription.copyWith(
              isPrinted: true,
              printedAt: DateTime.now(),
            ),
          ));
        }
      },
    );
  }
}
