import 'package:equatable/equatable.dart';
import 'doctor_question_entity.dart';
import 'doctor_template_entity.dart';
import 'previous_visit_entity.dart';
import 'visit_image_entity.dart';
import 'visit_patient_entity.dart';
import 'vital_signs_entity.dart';

class ExaminationEntity extends Equatable {
  final int id;
  final String visitNumber;
  final String status;
  final VisitPatientEntity patient;
  final VitalSignsEntity? vitalSigns;
  final String? chiefComplaint;
  final String? diagnosis;
  final String? notes;
  final int? followupDays;
  final String? followupNotes;
  final List<VisitImageEntity> images;
  final List<DoctorQuestionEntity> questions;
  final List<PreviousVisitEntity> previousVisits;
  final int pastVisitsCount;
  final String visitTypeLabel;
  final bool isFirstVisit;
  final List<DoctorTemplateEntity> complaintTemplates;
  final List<DoctorTemplateEntity> diagnosisTemplates;

  const ExaminationEntity({
    required this.id,
    required this.visitNumber,
    required this.status,
    required this.patient,
    this.vitalSigns,
    this.chiefComplaint,
    this.diagnosis,
    this.notes,
    this.followupDays,
    this.followupNotes,
    this.images = const [],
    this.questions = const [],
    this.previousVisits = const [],
    this.pastVisitsCount = 0,
    this.visitTypeLabel = '',
    this.isFirstVisit = true,
    this.complaintTemplates = const [],
    this.diagnosisTemplates = const [],
  });

  bool get isCompleted => status == 'completed';

  ExaminationEntity copyWith({
    int? id,
    String? visitNumber,
    String? status,
    VisitPatientEntity? patient,
    VitalSignsEntity? vitalSigns,
    String? chiefComplaint,
    String? diagnosis,
    String? notes,
    int? followupDays,
    String? followupNotes,
    List<VisitImageEntity>? images,
    List<DoctorQuestionEntity>? questions,
    List<PreviousVisitEntity>? previousVisits,
    int? pastVisitsCount,
    String? visitTypeLabel,
    bool? isFirstVisit,
    List<DoctorTemplateEntity>? complaintTemplates,
    List<DoctorTemplateEntity>? diagnosisTemplates,
  }) {
    return ExaminationEntity(
      id: id ?? this.id,
      visitNumber: visitNumber ?? this.visitNumber,
      status: status ?? this.status,
      patient: patient ?? this.patient,
      vitalSigns: vitalSigns ?? this.vitalSigns,
      chiefComplaint: chiefComplaint ?? this.chiefComplaint,
      diagnosis: diagnosis ?? this.diagnosis,
      notes: notes ?? this.notes,
      followupDays: followupDays ?? this.followupDays,
      followupNotes: followupNotes ?? this.followupNotes,
      images: images ?? this.images,
      questions: questions ?? this.questions,
      previousVisits: previousVisits ?? this.previousVisits,
      pastVisitsCount: pastVisitsCount ?? this.pastVisitsCount,
      visitTypeLabel: visitTypeLabel ?? this.visitTypeLabel,
      isFirstVisit: isFirstVisit ?? this.isFirstVisit,
      complaintTemplates: complaintTemplates ?? this.complaintTemplates,
      diagnosisTemplates: diagnosisTemplates ?? this.diagnosisTemplates,
    );
  }

  @override
  List<Object?> get props => [
        id,
        visitNumber,
        status,
        patient,
        vitalSigns,
        chiefComplaint,
        diagnosis,
        notes,
        followupDays,
        followupNotes,
        images,
        questions,
        previousVisits,
        pastVisitsCount,
        visitTypeLabel,
        isFirstVisit,
        complaintTemplates,
        diagnosisTemplates,
      ];
}
