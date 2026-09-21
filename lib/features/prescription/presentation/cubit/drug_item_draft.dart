import 'package:equatable/equatable.dart';
import '../../domain/entities/prescription_item_entity.dart';

class DrugItemDraft extends Equatable {
  final String id; // temporary unique key for UI list keys
  final String drugName;
  final String dosage;
  final String frequency;
  final String duration;
  final String route;
  final String notes;

  const DrugItemDraft({
    required this.id,
    this.drugName = '',
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.route = 'oral',
    this.notes = '',
  });

  factory DrugItemDraft.fromEntity(PrescriptionItemEntity entity) {
    return DrugItemDraft(
      id: entity.id.toString(),
      drugName: entity.drugName,
      dosage: entity.dosage,
      frequency: entity.frequency,
      duration: entity.duration,
      route: entity.route,
      notes: entity.notes ?? '',
    );
  }

  DrugItemDraft copyWith({
    String? id,
    String? drugName,
    String? dosage,
    String? frequency,
    String? duration,
    String? route,
    String? notes,
  }) {
    return DrugItemDraft(
      id: id ?? this.id,
      drugName: drugName ?? this.drugName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      route: route ?? this.route,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap({int sortOrder = 0}) {
    return {
      'drug_name': drugName.trim(),
      'dosage': dosage.trim(),
      'frequency': frequency.trim(),
      'duration': duration.trim(),
      'route': route.trim(),
      if (notes.trim().isNotEmpty) 'notes': notes.trim(),
      'sort_order': sortOrder,
    };
  }

  bool get isValid => drugName.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        id,
        drugName,
        dosage,
        frequency,
        duration,
        route,
        notes,
      ];
}
