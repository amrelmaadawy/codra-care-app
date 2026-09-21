import 'package:equatable/equatable.dart';

class VitalSignsEntity extends Equatable {
  final String? bloodPressure;
  final int? pulse;
  final double? temperature;
  final double? weightKg;
  final double? heightCm;
  final double? oxygenLevel;
  final int? respiratoryRate;
  final double? bloodSugar;
  final double? bmi;

  const VitalSignsEntity({
    this.bloodPressure,
    this.pulse,
    this.temperature,
    this.weightKg,
    this.heightCm,
    this.oxygenLevel,
    this.respiratoryRate,
    this.bloodSugar,
    this.bmi,
  });

  bool get hasData =>
      bloodPressure != null ||
      pulse != null ||
      temperature != null ||
      weightKg != null ||
      heightCm != null ||
      oxygenLevel != null ||
      respiratoryRate != null ||
      bloodSugar != null ||
      bmi != null;

  @override
  List<Object?> get props => [
        bloodPressure,
        pulse,
        temperature,
        weightKg,
        heightCm,
        oxygenLevel,
        respiratoryRate,
        bloodSugar,
        bmi,
      ];
}
