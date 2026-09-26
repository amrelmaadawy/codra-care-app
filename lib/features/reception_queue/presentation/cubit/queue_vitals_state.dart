import 'package:equatable/equatable.dart';
import '../../domain/entities/reception_queue_item_entity.dart';

enum QueueVitalsStatus { initial, submitting, success, error }

class QueueVitalsState extends Equatable {
  final int queueId;
  final int? bpSystolic;
  final int? bpDiastolic;
  final double? temperature;
  final int? pulse;
  final double? weightKg;
  final double? heightCm;
  final double? oxygenLevel;
  final int? respiratoryRate;
  final QueueVitalsStatus status;
  final String? errorMessage;
  final ReceptionQueueItemEntity? savedItem;

  const QueueVitalsState({
    required this.queueId,
    this.bpSystolic,
    this.bpDiastolic,
    this.temperature,
    this.pulse,
    this.weightKg,
    this.heightCm,
    this.oxygenLevel,
    this.respiratoryRate,
    this.status = QueueVitalsStatus.initial,
    this.errorMessage,
    this.savedItem,
  });

  bool get isSubmitting => status == QueueVitalsStatus.submitting;
  bool get isSuccess => status == QueueVitalsStatus.success;

  double? get computedBmi {
    if (weightKg != null && heightCm != null && heightCm! > 0) {
      final hM = heightCm! / 100.0;
      return double.parse((weightKg! / (hM * hM)).toStringAsFixed(1));
    }
    return null;
  }

  bool get hasAnyValue =>
      bpSystolic != null ||
      bpDiastolic != null ||
      temperature != null ||
      pulse != null ||
      weightKg != null ||
      heightCm != null ||
      oxygenLevel != null ||
      respiratoryRate != null;

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{};
    if (bpSystolic != null) payload['bp_systolic'] = bpSystolic;
    if (bpDiastolic != null) payload['bp_diastolic'] = bpDiastolic;
    if (temperature != null) payload['temperature'] = temperature;
    if (pulse != null) payload['pulse'] = pulse;
    if (weightKg != null) payload['weight_kg'] = weightKg;
    if (heightCm != null) payload['height_cm'] = heightCm;
    if (oxygenLevel != null) payload['oxygen_level'] = oxygenLevel;
    if (respiratoryRate != null) payload['respiratory_rate'] = respiratoryRate;
    return payload;
  }

  QueueVitalsState copyWith({
    int? Function()? bpSystolic,
    int? Function()? bpDiastolic,
    double? Function()? temperature,
    int? Function()? pulse,
    double? Function()? weightKg,
    double? Function()? heightCm,
    double? Function()? oxygenLevel,
    int? Function()? respiratoryRate,
    QueueVitalsStatus? status,
    String? Function()? errorMessage,
    ReceptionQueueItemEntity? savedItem,
  }) {
    return QueueVitalsState(
      queueId: queueId,
      bpSystolic: bpSystolic != null ? bpSystolic() : this.bpSystolic,
      bpDiastolic: bpDiastolic != null ? bpDiastolic() : this.bpDiastolic,
      temperature: temperature != null ? temperature() : this.temperature,
      pulse: pulse != null ? pulse() : this.pulse,
      weightKg: weightKg != null ? weightKg() : this.weightKg,
      heightCm: heightCm != null ? heightCm() : this.heightCm,
      oxygenLevel: oxygenLevel != null ? oxygenLevel() : this.oxygenLevel,
      respiratoryRate: respiratoryRate != null ? respiratoryRate() : this.respiratoryRate,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      savedItem: savedItem ?? this.savedItem,
    );
  }

  @override
  List<Object?> get props => [
    queueId,
    bpSystolic,
    bpDiastolic,
    temperature,
    pulse,
    weightKg,
    heightCm,
    oxygenLevel,
    respiratoryRate,
    status,
    errorMessage,
    savedItem,
  ];
}
