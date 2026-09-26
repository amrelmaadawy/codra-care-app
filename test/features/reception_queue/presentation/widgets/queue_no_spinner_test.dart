import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reception_queue feature contains ZERO Circular/Cupertino/Refresh spinners', () {
    final dir = Directory('lib/features/reception_queue');
    expect(dir.existsSync(), isTrue);

    final violations = <String>[];
    final regex = RegExp(r'\b(CircularProgressIndicator|CupertinoActivityIndicator|RefreshIndicator)\b');

    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        final content = entity.readAsStringSync();
        final matches = regex.allMatches(content);
        if (matches.isNotEmpty) {
          violations.add(
            '${entity.path} contains forbidden spinner: ${matches.map((m) => m.group(0)).toSet().join(', ')}',
          );
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: 'Rule Violation: reception_queue must use Shimmer only, found forbidden indicators:\n${violations.join('\n')}',
    );
  });
}
