import 'dart:convert';
import 'dart:io';
import 'package:medical_erp/features/prescription/data/models/paginated_prescriptions_model.dart';

void main() {
  final file = File(r'C:\Users\Lenovo\.gemini\antigravity-ide\brain\db6bea51-aa8e-4dce-8b02-c8667f73665d\scratch\resp_new.txt');
  final raw = file.readAsStringSync();
  final bodyIndex = raw.indexOf('\r\n\r\n');
  final body = raw.substring(bodyIndex + 4);
  final decoded = json.decode(body) as Map<String, dynamic>;
  final data = decoded['data'] as Map<String, dynamic>;

  try {
    final paginated = PaginatedPrescriptionsModel.fromJson(data);
    print('PaginatedPrescriptionsModel parsed successfully!');
    print('Count: ${paginated.items.length}, total: ${paginated.total}');
    for (final p in paginated.items) {
      print('  Rx: ${p.prescriptionNumber} for ${p.patient.fullName} (${p.items.length} meds)');
    }
  } catch (e, st) {
    print('Model parsing error: $e');
    print(st);
  }
}
