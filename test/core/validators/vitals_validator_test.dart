import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/core/validators/vitals_validator.dart';

void main() {
  group('VitalsValidator', () {
    test('blood pressure validation respects physiological format and ranges', () {
      expect(VitalsValidator.validateBloodPressure(null), isNull);
      expect(VitalsValidator.validateBloodPressure(''), isNull);
      expect(VitalsValidator.validateBloodPressure('120/80'), isNull);
      expect(VitalsValidator.validateBloodPressure('110 / 70'), isNull);

      // Invalid format
      expect(VitalsValidator.validateBloodPressure('23424'), isNotNull);
      expect(VitalsValidator.validateBloodPressure('abc'), isNotNull);

      // Out of physiological range
      expect(VitalsValidator.validateBloodPressure('300/80'), isNotNull);
      expect(VitalsValidator.validateBloodPressure('120/200'), isNotNull);

      // Diastolic >= systolic
      expect(VitalsValidator.validateBloodPressure('80/120'), isNotNull);
      expect(VitalsValidator.validateBloodPressure('100/100'), isNotNull);
    });

    test('pulse validation respects range 30-250', () {
      expect(VitalsValidator.validatePulse(null), isNull);
      expect(VitalsValidator.validatePulse(75), isNull);
      expect(VitalsValidator.validatePulse('75'), isNull);
      expect(VitalsValidator.validatePulse(1231231), isNotNull);
      expect(VitalsValidator.validatePulse(20), isNotNull);
      expect(VitalsValidator.validatePulse('invalid'), isNotNull);
    });

    test('temperature validation respects range 34-44', () {
      expect(VitalsValidator.validateTemperature(null), isNull);
      expect(VitalsValidator.validateTemperature(37.0), isNull);
      expect(VitalsValidator.validateTemperature('36.5'), isNull);
      expect(VitalsValidator.validateTemperature(123123), isNotNull);
      expect(VitalsValidator.validateTemperature(30.0), isNotNull);
    });

    test('oxygen level validation respects range 50-100', () {
      expect(VitalsValidator.validateOxygenLevel(null), isNull);
      expect(VitalsValidator.validateOxygenLevel(98), isNull);
      expect(VitalsValidator.validateOxygenLevel(2342324), isNotNull);
      expect(VitalsValidator.validateOxygenLevel(40), isNotNull);
    });

    test('validateAll catches first invalid vital sign', () {
      final invalidVitals = {
        'blood_pressure': '23424',
        'pulse': 1231231,
      };
      expect(VitalsValidator.validateAll(invalidVitals), isNotNull);

      final validVitals = {
        'blood_pressure': '120/80',
        'pulse': 72,
        'temperature': 37.0,
      };
      expect(VitalsValidator.validateAll(validVitals), isNull);
    });
  });
}
