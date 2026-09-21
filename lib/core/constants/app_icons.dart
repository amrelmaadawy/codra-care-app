import 'package:flutter/material.dart';

abstract final class AppIcons {
  // Navigation & Shell
  static const IconData dashboard = Icons.grid_view_outlined;
  static const IconData dashboardActive = Icons.grid_view_rounded;
  static const IconData queue = Icons.people_alt_outlined;
  static const IconData queueActive = Icons.people_alt;
  static const IconData patients = Icons.badge_outlined;
  static const IconData patientsActive = Icons.badge;
  static const IconData prescriptions = Icons.medication_outlined;
  static const IconData prescriptionsActive = Icons.medication;
  static const IconData reports = Icons.bar_chart_outlined;
  static const IconData reportsActive = Icons.bar_chart;
  static const IconData profile = Icons.person_outline;
  static const IconData profileActive = Icons.person;

  static const IconData reception = Icons.desk_outlined;
  static const IconData receptionActive = Icons.desk;
  static const IconData appointments = Icons.calendar_month_outlined;
  static const IconData appointmentsActive = Icons.calendar_month;
  static const IconData financial = Icons.account_balance_wallet_outlined;
  static const IconData financialActive = Icons.account_balance_wallet;
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsActive = Icons.settings;

  // Actions & Controls
  static const IconData search = Icons.search;
  static const IconData filter = Icons.tune;
  static const IconData refresh = Icons.refresh;
  static const IconData close = Icons.close;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData more = Icons.more_vert;
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData error = Icons.error_outline;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_outline;
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData logout = Icons.logout;
  static const IconData print = Icons.print_outlined;
  static const IconData share = Icons.share_outlined;
  static const IconData pdfExport = Icons.picture_as_pdf_outlined;

  // Medical specifics
  static const IconData vitals = Icons.monitor_heart_outlined;
  static const IconData consultation = Icons.medical_services_outlined;
  static const IconData clinic = Icons.local_hospital_outlined;
  static const IconData lock = Icons.lock_outline;
  static const IconData email = Icons.email_outlined;
}
