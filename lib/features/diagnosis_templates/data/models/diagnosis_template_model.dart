import '../../domain/entities/diagnosis_template_entity.dart';

class DiagnosisTemplateModel extends DiagnosisTemplateEntity {
  const DiagnosisTemplateModel({
    required super.id,
    required super.doctorId,
    required super.title,
    super.chiefComplaint,
    super.diagnosis,
    super.notes,
    super.usageCount,
    super.createdAt,
    super.updatedAt,
  });

  factory DiagnosisTemplateModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisTemplateModel(
      id: json['id'] as int? ?? 0,
      doctorId: json['doctor_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      chiefComplaint: json['chief_complaint'] as String?,
      diagnosis: json['diagnosis'] as String?,
      notes: json['notes'] as String?,
      usageCount: json['usage_count'] as int? ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'title': title,
      'chief_complaint': chiefComplaint,
      'diagnosis': diagnosis,
      'notes': notes,
      'usage_count': usageCount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
