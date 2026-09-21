import 'package:equatable/equatable.dart';

class PreviousVisitEntity extends Equatable {
  final int id;
  final String visitNumber;
  final String? visitDate;
  final String? chiefComplaint;
  final String? diagnosis;
  final String? notes;
  final String? doctorName;

  const PreviousVisitEntity({
    required this.id,
    required this.visitNumber,
    this.visitDate,
    this.chiefComplaint,
    this.diagnosis,
    this.notes,
    this.doctorName,
  });

  @override
  List<Object?> get props => [
        id,
        visitNumber,
        visitDate,
        chiefComplaint,
        diagnosis,
        notes,
        doctorName,
      ];
}
