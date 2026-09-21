import 'package:equatable/equatable.dart';

class PrescriptionItemEntity extends Equatable {
  final int id;
  final String drugName;
  final String dosage;
  final String frequency;
  final String duration;
  final String route;
  final String? notes;
  final int sortOrder;

  const PrescriptionItemEntity({
    required this.id,
    required this.drugName,
    this.dosage = '',
    this.frequency = '',
    this.duration = '',
    this.route = 'oral',
    this.notes,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [
        id,
        drugName,
        dosage,
        frequency,
        duration,
        route,
        notes,
        sortOrder,
      ];
}
