import '../../domain/entities/vital_signs_entity.dart';

class VitalSignsModel extends VitalSignsEntity {
  const VitalSignsModel({
    super.bpSystolic,
    super.bpDiastolic,
    super.bloodPressure,
    super.temperature,
    super.pulse,
    super.weightKg,
    super.heightCm,
    super.oxygenLevel,
    super.respiratoryRate,
    super.bmi,
  });

  factory VitalSignsModel.fromJson(Map<String, dynamic> json) {
    return VitalSignsModel(
      bpSystolic: (json['bp_systolic'] as num?)?.toInt(),
      bpDiastolic: (json['bp_diastolic'] as num?)?.toInt(),
      bloodPressure: json['blood_pressure'] as String?,
      temperature: (json['temperature'] as num?)?.toDouble(),
      pulse: (json['pulse'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toDouble(),
      heightCm: (json['height_cm'] as num?)?.toDouble(),
      oxygenLevel: (json['oxygen_level'] as num?)?.toDouble(),
      respiratoryRate: (json['respiratory_rate'] as num?)?.toInt(),
      bmi: (json['bmi'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bpSystolic != null) 'bp_systolic': bpSystolic,
      if (bpDiastolic != null) 'bp_diastolic': bpDiastolic,
      if (bloodPressure != null) 'blood_pressure': bloodPressure,
      if (temperature != null) 'temperature': temperature,
      if (pulse != null) 'pulse': pulse,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (oxygenLevel != null) 'oxygen_level': oxygenLevel,
      if (respiratoryRate != null) 'respiratory_rate': respiratoryRate,
      if (bmi != null) 'bmi': bmi,
    };
  }
}
