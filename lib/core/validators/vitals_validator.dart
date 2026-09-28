import 'package:easy_localization/easy_localization.dart';

abstract final class VitalsValidator {
  static final RegExp _bpRegex = RegExp(r'^\s*(\d{2,3})\s*/\s*(\d{2,3})\s*$');

  static String? validateBloodPressure(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final match = _bpRegex.firstMatch(value.trim());
    if (match == null) {
      return 'reception_booking.validation.bp_format'.tr();
    }
    final systolic = int.tryParse(match.group(1)!);
    final diastolic = int.tryParse(match.group(2)!);
    if (systolic == null || diastolic == null) {
      return 'reception_booking.validation.bp_format'.tr();
    }
    if (systolic < 50 || systolic > 260 || diastolic < 30 || diastolic > 160) {
      return 'reception_booking.validation.bp_range'.tr();
    }
    if (diastolic >= systolic) {
      return 'reception_booking.validation.bp_order'.tr();
    }
    return null;
  }

  static String? validatePulse(dynamic value) {
    if (value == null) return null;
    final val = value is int ? value : int.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 30 || val > 250) {
      return 'reception_booking.validation.pulse_range'.tr();
    }
    return null;
  }

  static String? validateTemperature(dynamic value) {
    if (value == null) return null;
    final val = value is num ? value.toDouble() : double.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 34.0 || val > 44.0) {
      return 'reception_booking.validation.temp_range'.tr();
    }
    return null;
  }

  static String? validateOxygenLevel(dynamic value) {
    if (value == null) return null;
    final val = value is num ? value.toDouble() : double.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 50 || val > 100) {
      return 'reception_booking.validation.oxygen_range'.tr();
    }
    return null;
  }

  static String? validateWeight(dynamic value) {
    if (value == null) return null;
    final val = value is num ? value.toDouble() : double.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 1.0 || val > 400.0) {
      return 'reception_booking.validation.weight_range'.tr();
    }
    return null;
  }

  static String? validateHeight(dynamic value) {
    if (value == null) return null;
    final val = value is num ? value.toDouble() : double.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 20 || val > 260) {
      return 'reception_booking.validation.height_range'.tr();
    }
    return null;
  }

  static String? validateRespiratoryRate(dynamic value) {
    if (value == null) return null;
    final val = value is int ? value : int.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 5 || val > 70) {
      return 'reception_booking.validation.respiratory_range'.tr();
    }
    return null;
  }

  static String? validateBloodSugar(dynamic value) {
    if (value == null) return null;
    final val = value is num ? value.toDouble() : double.tryParse(value.toString().trim());
    if (val == null) return 'reception_booking.validation.number_invalid'.tr();
    if (val < 20 || val > 600) {
      return 'reception_booking.validation.sugar_range'.tr();
    }
    return null;
  }

  static String? validateAll(Map<String, dynamic> vitals) {
    final bpErr = validateBloodPressure(vitals['blood_pressure']?.toString());
    if (bpErr != null) return bpErr;

    final pulseErr = validatePulse(vitals['pulse']);
    if (pulseErr != null) return pulseErr;

    final tempErr = validateTemperature(vitals['temperature']);
    if (tempErr != null) return tempErr;

    final oxyErr = validateOxygenLevel(vitals['oxygen_level']);
    if (oxyErr != null) return oxyErr;

    final weightErr = validateWeight(vitals['weight_kg']);
    if (weightErr != null) return weightErr;

    final heightErr = validateHeight(vitals['height_cm']);
    if (heightErr != null) return heightErr;

    final sugarErr = validateBloodSugar(vitals['blood_sugar']);
    if (sugarErr != null) return sugarErr;

    final respErr = validateRespiratoryRate(vitals['respiratory_rate']);
    if (respErr != null) return respErr;

    return null;
  }
}
