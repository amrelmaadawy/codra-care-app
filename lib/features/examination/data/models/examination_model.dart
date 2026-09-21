import '../../domain/entities/examination_entity.dart';
import 'doctor_question_model.dart';
import 'doctor_template_model.dart';
import 'previous_visit_model.dart';
import 'visit_image_model.dart';
import 'visit_patient_model.dart';
import 'vital_signs_model.dart';

class ExaminationModel extends ExaminationEntity {
  const ExaminationModel({
    required super.id,
    required super.visitNumber,
    required super.status,
    required super.patient,
    super.vitalSigns,
    super.chiefComplaint,
    super.diagnosis,
    super.notes,
    super.followupDays,
    super.followupNotes,
    super.images,
    super.questions,
    super.previousVisits,
    super.pastVisitsCount,
    super.visitTypeLabel,
    super.isFirstVisit,
    super.complaintTemplates,
    super.diagnosisTemplates,
  });

  factory ExaminationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> visitMap =
        json['visit'] is Map ? Map<String, dynamic>.from(json['visit'] as Map) : json;

    final Map<String, dynamic> patientMap = json['patient'] is Map
        ? Map<String, dynamic>.from(json['patient'] as Map)
        : (visitMap['patient'] is Map
            ? Map<String, dynamic>.from(visitMap['patient'] as Map)
            : <String, dynamic>{'id': 0, 'name': ''});

    // Vital signs
    VitalSignsModel? vitals;
    final rawVitals = visitMap['vital_signs'];
    if (rawVitals is Map) {
      vitals = VitalSignsModel.fromJson(Map<String, dynamic>.from(rawVitals));
    } else if (rawVitals is List && rawVitals.isNotEmpty && rawVitals.first is Map) {
      vitals = VitalSignsModel.fromJson(Map<String, dynamic>.from(rawVitals.first as Map));
    }

    // Images
    final List<VisitImageModel> images = [];
    final rawImages = visitMap['images'] ?? json['images'];
    if (rawImages is List) {
      for (final img in rawImages) {
        if (img is Map) {
          images.add(VisitImageModel.fromJson(Map<String, dynamic>.from(img)));
        }
      }
    }

    // Questions
    final List<DoctorQuestionModel> questions = [];
    final rawQuestions =
        json['doctorQuestions'] ?? json['doctor_questions'] ?? json['questions'];
    if (rawQuestions is List) {
      for (final q in rawQuestions) {
        if (q is Map) {
          questions.add(DoctorQuestionModel.fromJson(Map<String, dynamic>.from(q)));
        }
      }
    }

    // Previous visits
    final List<PreviousVisitModel> prevVisits = [];
    final rawPrev = json['previousVisits'] ?? json['previous_visits'];
    if (rawPrev is List) {
      for (final pv in rawPrev) {
        if (pv is Map) {
          prevVisits.add(PreviousVisitModel.fromJson(Map<String, dynamic>.from(pv)));
        }
      }
    }

    // Templates
    final List<DoctorTemplateModel> compTemplates = [];
    final rawComp = json['complaintTemplates'] ?? json['complaint_templates'];
    if (rawComp is List) {
      for (final t in rawComp) {
        if (t is Map) {
          compTemplates.add(DoctorTemplateModel.fromJson(Map<String, dynamic>.from(t)));
        }
      }
    }

    final List<DoctorTemplateModel> diagTemplates = [];
    final rawDiag = json['diagnosisTemplates'] ?? json['diagnosis_templates'];
    if (rawDiag is List) {
      for (final t in rawDiag) {
        if (t is Map) {
          diagTemplates.add(DoctorTemplateModel.fromJson(Map<String, dynamic>.from(t)));
        }
      }
    }

    // Visit type info
    final typeInfo = json['visitTypeInfo'] ?? json['visit_type_info'];
    String visitLabel = '';
    bool isFirst = true;
    if (typeInfo is Map) {
      visitLabel = typeInfo['label'] as String? ?? '';
      isFirst = typeInfo['is_first_visit'] == true;
    }

    int? fDays;
    if (visitMap['followup_days'] != null) {
      fDays = int.tryParse(visitMap['followup_days'].toString());
    }

    final rawStatus = visitMap['status'] ?? 'in_progress';
    final statusStr = rawStatus is Map ? rawStatus['value'] : rawStatus.toString();

    return ExaminationModel(
      id: visitMap['id'] as int? ?? 0,
      visitNumber: visitMap['visit_number'] as String? ?? '',
      status: statusStr,
      patient: VisitPatientModel.fromJson(patientMap),
      vitalSigns: vitals,
      chiefComplaint: visitMap['chief_complaint'] as String?,
      diagnosis: visitMap['diagnosis'] as String?,
      notes: visitMap['notes'] as String?,
      followupDays: fDays,
      followupNotes: visitMap['followup_notes'] as String?,
      images: images,
      questions: questions,
      previousVisits: prevVisits,
      pastVisitsCount: json['pastVisitsCount'] as int? ?? 0,
      visitTypeLabel: visitLabel,
      isFirstVisit: isFirst,
      complaintTemplates: compTemplates,
      diagnosisTemplates: diagTemplates,
    );
  }
}
