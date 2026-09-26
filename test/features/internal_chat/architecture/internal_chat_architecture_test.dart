import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Internal Chat Architecture & Rule Compliance Tests', () {
    final chatDirectory = Directory('lib/features/internal_chat');

    test('Every file in internal_chat must have fewer than 200 lines (Rule 3)', () {
      expect(chatDirectory.existsSync(), isTrue,
          reason: 'lib/features/internal_chat directory must exist');

      final files = chatDirectory
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();

      expect(files, isNotEmpty, reason: 'There must be dart files in internal_chat');

      final violations = <String>[];

      for (final file in files) {
        final lines = file.readAsLinesSync().length;
        if (lines > 200) {
          violations.add('${file.path}: $lines lines');
        }
      }

      expect(violations, isEmpty,
          reason:
              'Files exceeding 200 lines limit:\n${violations.join('\n')}');
    });

    test('Internal chat presentation must strictly use Shimmer (no Circular/Cupertino/Refresh indicators)', () {
      final presentationDir = Directory('lib/features/internal_chat/presentation');
      expect(presentationDir.existsSync(), isTrue);

      final files = presentationDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();

      final violations = <String>[];

      for (final file in files) {
        final content = file.readAsStringSync();
        if (content.contains('CircularProgressIndicator')) {
          violations.add('${file.path} contains CircularProgressIndicator');
        }
        if (content.contains('CupertinoActivityIndicator')) {
          violations.add('${file.path} contains CupertinoActivityIndicator');
        }
        if (content.contains('RefreshIndicator(') ||
            content.contains('RefreshIndicator.')) {
          violations.add('${file.path} contains RefreshIndicator');
        }
      }

      expect(violations, isEmpty,
          reason: 'Violations of shimmer-only rule:\n${violations.join('\n')}');
    });
  });
}
