import '../../domain/entities/prescription_item_entity.dart';

class PrescriptionItemModel extends PrescriptionItemEntity {
  const PrescriptionItemModel({
    required super.id,
    required super.drugName,
    super.dosage,
    super.frequency,
    super.duration,
    super.route,
    super.notes,
    super.sortOrder,
  });

  factory PrescriptionItemModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemModel(
      id: json['id'] as int? ?? 0,
      drugName: (json['drug_name'] as String?) ?? '',
      dosage: (json['dosage'] as String?) ?? '',
      frequency: (json['frequency'] as String?) ?? '',
      duration: (json['duration'] as String?) ?? '',
      route: (json['route'] as String?) ?? 'oral',
      notes: json['notes'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'drug_name': drugName,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'route': route,
      'notes': notes,
      'sort_order': sortOrder,
    };
  }
}
