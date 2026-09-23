import 'dart:convert';
import 'dart:io';

void main() {
  final file = File(r'C:\Users\Lenovo\.gemini\antigravity-ide\brain\db6bea51-aa8e-4dce-8b02-c8667f73665d\scratch\resp_new.txt');
  final raw = file.readAsStringSync();
  final bodyIndex = raw.indexOf('\r\n\r\n');
  final body = raw.substring(bodyIndex + 4);
  print('Body length: ${body.length}');
  try {
    final decoded = json.decode(body) as Map<String, dynamic>;
    print('Decoded successfully! success: ${decoded['success']}');
    final data = decoded['data'] as Map<String, dynamic>;
    final items = data['data'] as List;
    print('Total prescriptions in page: ${items.length}');
  } catch (e) {
    print('Decode error: $e');
  }
}
