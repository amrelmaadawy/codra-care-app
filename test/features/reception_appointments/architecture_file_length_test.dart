import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'All reception_appointments and reception_booking files must have <= 200 lines',
    () {
      final dirs = [
        'lib/features/reception_appointments',
        'lib/features/reception_booking',
        'lib/features/reception_dashboard',
      ];

      final violations = <String>[];

      for (final dirPath in dirs) {
        final dir = Directory(dirPath);
        if (!dir.existsSync()) continue;

        for (final entity in dir.listSync(recursive: true)) {
          if (entity is File && entity.path.endsWith('.dart')) {
            final lines = entity.readAsLinesSync().length;
            if (lines > 200) {
              violations.add(
                '${entity.path} has $lines lines (max 200 allowed)',
              );
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Rule 3 Violation: Found files exceeding 200 lines:\n${violations.join('\n')}',
      );
    },
  );
}
