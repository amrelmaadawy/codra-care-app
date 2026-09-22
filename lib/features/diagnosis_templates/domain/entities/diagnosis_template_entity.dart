import 'package:equatable/equatable.dart';

class DiagnosisTemplateEntity extends Equatable {
  final int id;
  final int doctorId;
  final String title;
  final String? chiefComplaint;
  final String? diagnosis;
  final String? notes;
  final int usageCount;
  final String? createdAt;
  final String? updatedAt;

  const DiagnosisTemplateEntity({
    required this.id,
    required this.doctorId,
    required this.title,
    this.chiefComplaint,
    this.diagnosis,
    this.notes,
    this.usageCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  bool get hasChiefComplaint =>
      chiefComplaint != null && chiefComplaint!.trim().isNotEmpty;

  bool get hasDiagnosis =>
      diagnosis != null && diagnosis!.trim().isNotEmpty;

  bool get hasNotes =>
      notes != null && notes!.trim().isNotEmpty;

  DiagnosisTemplateEntity copyWith({
    int? id,
    int? doctorId,
    String? title,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
    int? usageCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return DiagnosisTemplateEntity(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      title: title ?? this.title,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      usageCount: usageCount ?? this.usageCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        title,
        chiefComplaint,
        diagnosis,
        notes,
        usageCount,
        createdAt,
        updatedAt,
      ];
}
