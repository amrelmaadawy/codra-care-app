abstract final class AppPermissions {
  // Dashboard
  static const String dashboardView = 'dashboard.view';

  // Reception & Queue
  static const String receptionView = 'reception.view';
  static const String receptionQueueView = 'reception.queue.view';
  static const String receptionQueueCallDoc = 'reception.queue.call_doctor';
  static const String receptionAddWalkIn = 'reception.queue.add_walk_in';
  static const String receptionSaveVitals = 'reception.queue.save_vitals';
  static const String receptionComplete = 'reception.queue.complete';

  // Appointments
  static const String appointmentsView = 'reception.appointments.view';
  static const String appointmentsCreate = 'reception.appointments.create';
  static const String appointmentsCheckIn = 'reception.appointments.check_in';

  // Patients
  static const String patientsView = 'patients.view';
  static const String patientsCreate = 'patients.create';
  static const String patientsEdit = 'patients.edit';

  // Doctor & Consultations
  static const String doctorQueueView = 'doctor.queue.view';
  static const String doctorConsultationStart = 'doctor.consultation.start';
  static const String doctorConsultationComplete = 'doctor.consultation.complete';

  // Prescriptions
  static const String prescriptionsView = 'prescriptions.view';
  static const String prescriptionsCreate = 'prescriptions.create';

  // Financial & Billing
  static const String billingView = 'billing.view';
  static const String billingCreate = 'billing.create';

  // Reports
  static const String reportsView = 'reports.view';
}
