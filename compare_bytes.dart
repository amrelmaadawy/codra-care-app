import 'dart:io';

void main() async {
  final respFile = File(r'C:\Users\Lenovo\.gemini\antigravity-ide\brain\db6bea51-aa8e-4dce-8b02-c8667f73665d\scratch\resp.txt');
  final respBytes = respFile.readAsBytesSync();
  int headerEnd = 0;
  for (int i = 0; i < respBytes.length - 3; i++) {
    if (respBytes[i] == 13 && respBytes[i+1] == 10 && respBytes[i+2] == 13 && respBytes[i+3] == 10) {
      headerEnd = i + 4;
      break;
    }
  }

  final received = respBytes.sublist(headerEnd);
  final original = File(r'C:\Users\Lenovo\.gemini\antigravity-ide\brain\db6bea51-aa8e-4dce-8b02-c8667f73665d\scratch\original.txt').readAsBytesSync();

  print('Received length: ${received.length}');
  print('Original length: ${original.length}');

  int r = 0, o = 0;
  int missingCount = 0;
  while (r < received.length && o < original.length) {
    if (received[r] == original[o]) {
      r++;
      o++;
    } else {
      missingCount++;
      print('Mismatch #$missingCount: at orig index $o (byte 0x${original[o].toRadixString(16)} "${String.fromCharCode(original[o])}") vs recv index $r (0x${received[r].toRadixString(16)} "${String.fromCharCode(received[r])}")');
      print('  Around orig: ${String.fromCharCodes(original.sublist(o - 15, o + 20))}');
      // Advance original to see if byte was dropped
      o++;
    }
  }
}
