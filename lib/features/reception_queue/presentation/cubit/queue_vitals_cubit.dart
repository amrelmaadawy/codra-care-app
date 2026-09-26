import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/vital_signs_entity.dart';
import '../../domain/use_cases/save_queue_vitals_use_case.dart';
import 'queue_vitals_state.dart';

class QueueVitalsCubit extends Cubit<QueueVitalsState> {
  final SaveQueueVitalsUseCase saveQueueVitalsUseCase;

  QueueVitalsCubit({
    required int queueId,
    VitalSignsEntity? initialVitals,
    required this.saveQueueVitalsUseCase,
  }) : super(QueueVitalsState(
          queueId: queueId,
          bpSystolic: initialVitals?.bpSystolic,
          bpDiastolic: initialVitals?.bpDiastolic,
          temperature: initialVitals?.temperature,
          pulse: initialVitals?.pulse,
          weightKg: initialVitals?.weightKg,
          heightCm: initialVitals?.heightCm,
          oxygenLevel: initialVitals?.oxygenLevel,
          respiratoryRate: initialVitals?.respiratoryRate,
        ));

  void setBpSystolic(int? value) => emit(state.copyWith(bpSystolic: () => value));
  void setBpDiastolic(int? value) => emit(state.copyWith(bpDiastolic: () => value));
  void setTemperature(double? value) => emit(state.copyWith(temperature: () => value));
  void setPulse(int? value) => emit(state.copyWith(pulse: () => value));
  void setWeightKg(double? value) => emit(state.copyWith(weightKg: () => value));
  void setHeightCm(double? value) => emit(state.copyWith(heightCm: () => value));
  void setOxygenLevel(double? value) => emit(state.copyWith(oxygenLevel: () => value));
  void setRespiratoryRate(int? value) => emit(state.copyWith(respiratoryRate: () => value));

  Future<void> submit() async {
    if (!state.hasAnyValue) {
      emit(state.copyWith(errorMessage: () => 'reception_queue.vitals_required_validation'));
      return;
    }

    if (state.bpSystolic != null && state.bpDiastolic != null) {
      if (state.bpDiastolic! >= state.bpSystolic!) {
        emit(state.copyWith(errorMessage: () => 'reception_queue.bp_diastolic_greater_than_systolic'));
        return;
      }
    }

    emit(state.copyWith(status: QueueVitalsStatus.submitting, errorMessage: () => null));

    final result = await saveQueueVitalsUseCase(
      id: state.queueId,
      vitals: state.toPayload(),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: QueueVitalsStatus.error,
        errorMessage: () => failure.message,
      )),
      (savedItem) => emit(state.copyWith(
        status: QueueVitalsStatus.success,
        savedItem: savedItem,
        errorMessage: () => null,
      )),
    );
  }
}
