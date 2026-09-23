import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'C:\Users\Lenovo\.gemini\antigravity-ide\brain\db6bea51-aa8e-4dce-8b02-c8667f73665d\scratch\resp.txt');
  final raw = file.readAsStringSync();
  // Find where body starts (\r\n\r\n)
  final bodyIndex = raw.indexOf('\r\n\r\n');
  final body = raw.substring(bodyIndex + 4);
  print('Body length: ${body.length}');
  try {
    final decoded = json.decode(body);
    print('Decoded successfully! Success: ${decoded['success']}');
  } catch (e) {
    print('Decode error: $e');
  }
}
