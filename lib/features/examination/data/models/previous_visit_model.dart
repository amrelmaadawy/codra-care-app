import '../../domain/entities/previous_visit_entity.dart';

class PreviousVisitModel extends PreviousVisitEntity {
  const PreviousVisitModel({
    required super.id,
    required super.visitNumber,
    super.visitDate,
    super.chiefComplaint,
    super.diagnosis,
    super.notes,
    super.doctorName,
  });

  factory PreviousVisitModel.fromJson(Map<String, dynamic> json) {
    String? docName;
    if (json['doctor'] != null && json['doctor'] is Map) {
      docName = json['doctor']['name'] as String?;
    } else if (json['doctor_name'] != null) {
      docName = json['doctor_name'] as String?;
    }

    return PreviousVisitModel(
      id: json['id'] as int,
      visitNumber: json['visit_number'] as String? ?? '',
      visitDate: json['visit_date'] as String?,
      chiefComplaint: json['chief_complaint'] as String?,
      diagnosis: json['diagnosis'] as String?,
      notes: json['notes'] as String?,
      doctorName: docName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_number': visitNumber,
      'visit_date': visitDate,
      'chief_complaint': chiefComplaint,
      'diagnosis': diagnosis,
      'notes': notes,
      'doctor_name': doctorName,
    };
  }
}
