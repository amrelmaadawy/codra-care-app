import '../../domain/entities/doctor_question_entity.dart';

class PredefinedQuestionTemplate {
  final String textKey;
  final DoctorQuestionType type;
  final List<String> options;
  final bool isRequired;

  const PredefinedQuestionTemplate({
    required this.textKey,
    required this.type,
    this.options = const [],
    this.isRequired = false,
  });
}

const List<PredefinedQuestionTemplate> kPredefinedQuestionTemplates = [
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.allergies',
    type: DoctorQuestionType.yesNo,
    isRequired: true,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.chronic_diseases',
    type: DoctorQuestionType.multipleChoice,
    options: ['ضغط دم', 'سكري', 'أمراض قلب', 'ربو حساسية صدور', 'لا يوجد'],
    isRequired: true,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.current_medications',
    type: DoctorQuestionType.text,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.previous_surgeries',
    type: DoctorQuestionType.yesNo,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.chief_complaint',
    type: DoctorQuestionType.text,
    isRequired: true,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.smoking',
    type: DoctorQuestionType.yesNo,
  ),
  PredefinedQuestionTemplate(
    textKey: 'doctor_questions.templates.blood_type',
    type: DoctorQuestionType.multipleChoice,
    options: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
  ),
];
