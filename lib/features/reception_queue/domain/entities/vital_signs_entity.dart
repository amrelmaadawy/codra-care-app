import 'package:equatable/equatable.dart';

class VitalSignsEntity extends Equatable {
  final int? bpSystolic;
  final int? bpDiastolic;
  final String? bloodPressure;
  final double? temperature;
  final int? pulse;
  final double? weightKg;
  final double? heightCm;
  final double? oxygenLevel;
  final int? respiratoryRate;
  final double? bmi;

  const VitalSignsEntity({
    this.bpSystolic,
    this.bpDiastolic,
    this.bloodPressure,
    this.temperature,
    this.pulse,
    this.weightKg,
    this.heightCm,
    this.oxygenLevel,
    this.respiratoryRate,
    this.bmi,
  });

  bool get hasAny =>
      bpSystolic != null ||
      bpDiastolic != null ||
      bloodPressure != null ||
      temperature != null ||
      pulse != null ||
      weightKg != null ||
      heightCm != null ||
      oxygenLevel != null ||
      respiratoryRate != null ||
      bmi != null;

  String get bmiCategoryKey {
    if (bmi == null) return '';
    if (bmi! < 18.5) return 'reception_queue.bmi_underweight';
    if (bmi! < 25.0) return 'reception_queue.bmi_normal';
    if (bmi! < 30.0) return 'reception_queue.bmi_overweight';
    return 'reception_queue.bmi_obese';
  }

  @override
  List<Object?> get props => [
    bpSystolic,
    bpDiastolic,
    bloodPressure,
    temperature,
    pulse,
    weightKg,
    heightCm,
    oxygenLevel,
    respiratoryRate,
    bmi,
  ];
}
