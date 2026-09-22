abstract final class DoctorEndpoints {
  static const String dashboard = '/doctor/dashboard';
  static const String queue = '/doctor/queue';
  static String callQueue(int id) => '/doctor/queue/$id/call';
  static String completeQueue(int id) => '/doctor/queue/$id/complete';
  static String cancelQueue(int id) => '/doctor/queue/$id/cancel';

  // Examination
  static String startExamination(int waitingListId) => '/doctor/examination/start/$waitingListId';
  static String examination(int visitId) => '/doctor/examination/$visitId';
  static String saveExaminationSection(int visitId) => '/doctor/examination/$visitId/section';
  static String uploadExaminationFiles(int visitId) => '/doctor/examination/$visitId/files';
  static String deleteExaminationFile(int visitId, int imageId) => '/doctor/examination/$visitId/files/$imageId';
  static String completeExamination(int visitId) => '/doctor/examination/$visitId/complete';
  static String copyPreviousVisit(int visitId, int prevId) => '/doctor/examination/$visitId/previous-visit/$prevId/copy';

  // Prescriptions
  static const String prescriptions = '/doctor/prescriptions';
  static String prescriptionDetail(int id) => '/doctor/prescriptions/$id';
  static String prescriptionCopy(int id) => '/doctor/prescriptions/$id/copy';
  static String prescriptionMarkPrinted(int id) => '/doctor/prescriptions/$id/mark-printed';
  static const String prescriptionCreateContext = '/doctor/prescriptions/context/create';

  // Patients
  static const String patients = '/doctor/patients';
  static String patientDetail(int id) => '/doctor/patients/$id';

  // Diagnosis Templates
  static const String diagnosisTemplates = '/doctor/diagnosis-templates';
  static const String diagnosisTemplatesForExam = '/doctor/diagnosis-templates/examination';
  static String diagnosisTemplateDetail(int id) => '/doctor/diagnosis-templates/$id';
  static String diagnosisTemplateUpdate(int id) => '/doctor/diagnosis-templates/$id';
  static String diagnosisTemplateDelete(int id) => '/doctor/diagnosis-templates/$id';
  static String diagnosisTemplateUse(int id) => '/doctor/diagnosis-templates/$id/use';

  // Doctor Questions
  static const String questions = '/doctor/questions';
  static String questionDetail(int id) => '/doctor/questions/$id';
  static String questionToggle(int id) => '/doctor/questions/$id/toggle';
  static const String questionsReorder = '/doctor/questions/reorder';

  // Doctor Leave Days
  static const String leaveDays = '/doctor/leave-days';
  static const String leaveDaysByDate = '/doctor/leave-days/by-date';
  static const String leaveDaysAppointmentsCount = '/doctor/leave-days/appointments-count';
  static String leaveDayDetail(int id) => '/doctor/leave-days/$id';
}


