import 'package:equatable/equatable.dart';
import 'prescription_item_entity.dart';
import 'prescription_patient_entity.dart';

class PrescriptionEntity extends Equatable {
  final int id;
  final String prescriptionNumber;
  final PrescriptionPatientEntity patient;
  final int? visitId;
  final String? visitNumber;
  final String? notes;
  final bool isPrinted;
  final DateTime? printedAt;
  final List<PrescriptionItemEntity> items;
  final DateTime? createdAt;

  const PrescriptionEntity({
    required this.id,
    required this.prescriptionNumber,
    required this.patient,
    this.visitId,
    this.visitNumber,
    this.notes,
    this.isPrinted = false,
    this.printedAt,
    this.items = const [],
    this.createdAt,
  });

  PrescriptionEntity copyWith({
    int? id,
    String? prescriptionNumber,
    PrescriptionPatientEntity? patient,
    int? visitId,
    String? visitNumber,
    String? notes,
    bool? isPrinted,
    DateTime? printedAt,
    List<PrescriptionItemEntity>? items,
    DateTime? createdAt,
  }) {
    return PrescriptionEntity(
      id: id ?? this.id,
      prescriptionNumber: prescriptionNumber ?? this.prescriptionNumber,
      patient: patient ?? this.patient,
      visitId: visitId ?? this.visitId,
      visitNumber: visitNumber ?? this.visitNumber,
      notes: notes ?? this.notes,
      isPrinted: isPrinted ?? this.isPrinted,
      printedAt: printedAt ?? this.printedAt,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        prescriptionNumber,
        patient,
        visitId,
        visitNumber,
        notes,
        isPrinted,
        printedAt,
        items,
        createdAt,
      ];
}
