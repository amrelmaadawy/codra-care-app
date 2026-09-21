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
