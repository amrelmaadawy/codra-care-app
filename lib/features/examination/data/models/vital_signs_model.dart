import '../../domain/entities/vital_signs_entity.dart';

class VitalSignsModel extends VitalSignsEntity {
  const VitalSignsModel({
    super.bloodPressure,
    super.pulse,
    super.temperature,
    super.weightKg,
    super.heightCm,
    super.oxygenLevel,
    super.respiratoryRate,
    super.bloodSugar,
    super.bmi,
  });

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    String? bp = json['blood_pressure']?.toString() ?? json['bp']?.toString();
    if (bp == null && json['blood_pressure_systolic'] != null) {
      final sys = json['blood_pressure_systolic'];
      final dia = json['blood_pressure_diastolic'];
      bp = dia != null ? '$sys/$dia' : sys.toString();
    }

    int? pulse;
    final rawPulse = json['pulse'] ?? json['pulse_rate'] ?? json['heart_rate'];
    if (rawPulse != null) {
      pulse = int.tryParse(rawPulse.toString());
    }

    double? temp;
    final rawTemp = json['temperature'] ?? json['temp'];
    if (rawTemp != null) {
      temp = double.tryParse(rawTemp.toString());
    }

    double? weight;
    final rawWeight = json['weight_kg'] ?? json['weight'];
    if (rawWeight != null) {
      weight = double.tryParse(rawWeight.toString());
    }

    double? height;
    final rawHeight = json['height_cm'] ?? json['height'];
    if (rawHeight != null) {
      height = double.tryParse(rawHeight.toString());
    }

    double? oxygen;
    final rawO2 = json['oxygen_level'] ?? json['sp_o2'] ?? json['spo2'];
    if (rawO2 != null) {
      oxygen = double.tryParse(rawO2.toString());
    }

    int? rr;
    final rawRr = json['respiratory_rate'] ?? json['rr'];
    if (rawRr != null) {
      rr = int.tryParse(rawRr.toString());
    }

    double? sugar;
    final rawSugar = json['blood_sugar'] ?? json['sugar'];
    if (rawSugar != null) {
      sugar = double.tryParse(rawSugar.toString());
    }

    double? bmi;
    final rawBmi = json['bmi'];
    if (rawBmi != null) {
      bmi = double.tryParse(rawBmi.toString());
    } else if (weight != null && height != null && height > 0) {
      final heightM = height / 100;
      bmi = double.parse((weight / (heightM * heightM)).toStringAsFixed(1));
    }

    return VitalSignsModel(
      bloodPressure: bp,
      pulse: pulse,
      temperature: temp,
      weightKg: weight,
      heightCm: height,
      oxygenLevel: oxygen,
      respiratoryRate: rr,
      bloodSugar: sugar,
      bmi: bmi,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bloodPressure != null) 'blood_pressure': bloodPressure,
      if (pulse != null) 'pulse': pulse,
      if (temperature != null) 'temperature': temperature,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (oxygenLevel != null) 'oxygen_level': oxygenLevel,
      if (respiratoryRate != null) 'respiratory_rate': respiratoryRate,
      if (bloodSugar != null) 'blood_sugar': bloodSugar,
      if (bmi != null) 'bmi': bmi,
    };
  }
}
