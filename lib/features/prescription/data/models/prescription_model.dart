import '../../domain/entities/prescription_entity.dart';
import 'prescription_item_model.dart';
import 'prescription_patient_model.dart';

class PrescriptionModel extends PrescriptionEntity {
  const PrescriptionModel({
    required super.id,
    required super.prescriptionNumber,
    required super.patient,
    super.visitId,
    super.visitNumber,
    super.notes,
    super.isPrinted,
    super.printedAt,
    super.items,
    super.createdAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    final patientJson = json['patient'] is Map<String, dynamic>
        ? json['patient'] as Map<String, dynamic>
        : <String, dynamic>{
            'id': json['patient_id'] as int? ?? 0,
            'full_name': 'مريض',
          };

    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(PrescriptionItemModel.fromJson)
        .toList();

    String? visitNumber;
    if (json['visit'] is Map<String, dynamic>) {
      visitNumber = (json['visit'] as Map<String, dynamic>)['visit_number'] as String?;
    }

    DateTime? printedAt;
    if (json['printed_at'] != null) {
      printedAt = DateTime.tryParse(json['printed_at'].toString());
    }

    DateTime? createdAt;
    if (json['created_at'] != null) {
      createdAt = DateTime.tryParse(json['created_at'].toString());
    }

    return PrescriptionModel(
      id: json['id'] as int? ?? 0,
      prescriptionNumber: (json['prescription_number'] as String?) ?? '',
      patient: PrescriptionPatientModel.fromJson(patientJson),
      visitId: json['visit_id'] as int?,
      visitNumber: visitNumber,
      notes: json['notes'] as String?,
      isPrinted: json['is_printed'] == true || json['is_printed'] == 1,
      printedAt: printedAt,
      items: items,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prescription_number': prescriptionNumber,
      'patient_id': patient.id,
      'visit_id': visitId,
      'notes': notes,
      'is_printed': isPrinted,
      'items': items.map((e) => (e as PrescriptionItemModel).toJson()).toList(),
    };
  }
}
