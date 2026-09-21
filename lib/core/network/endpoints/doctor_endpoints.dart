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
}
