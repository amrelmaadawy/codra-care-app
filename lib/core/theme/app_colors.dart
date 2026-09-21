import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary Teal Palette
  static const Color primary = Color(0xFF006B6B);
  static const Color primaryLight = Color(0xFF4D9D9D);
  static const Color primaryDark = Color(0xFF004A4A);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Accent Amber
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBD26A);
  static const Color onAccent = Color(0xFF1C1C1C);

  // Semantic Colors
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF9C3);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Dark Theme Backgrounds & Surfaces
  static const Color backgroundDark = Color(0xFF0F1723);
  static const Color surfaceDark = Color(0xFF1A2535);
  static const Color surfaceVariantDark = Color(0xFF243044);
  static const Color dividerDark = Color(0xFF2D3E52);
  static const Color onBackgroundDark = Color(0xFFE8EDF2);
  static const Color onSurfaceDark = Color(0xFFCDD5E0);
  static const Color onSurfaceMutedDark = Color(0xFF7A8FA6);

  // Light Theme Backgrounds & Surfaces
  static const Color backgroundLight = Color(0xFFF0F4F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFE8EEF4);
  static const Color dividerLight = Color(0xFFD1DCE8);
  static const Color onBackgroundLight = Color(0xFF1A2535);
  static const Color onSurfaceLight = Color(0xFF2D3E52);
  static const Color onSurfaceMutedLight = Color(0xFF6B7A8D);

  // Status Colors (Appointment / Waiting)
  static const Color statusScheduled = Color(0xFF3B82F6);
  static const Color statusConfirmed = Color(0xFF8B5CF6);
  static const Color statusInConsultation = Color(0xFFF59E0B);
  static const Color statusCompleted = Color(0xFF22C55E);
  static const Color statusCancelled = Color(0xFFEF4444);
  static const Color statusWaiting = Color(0xFF06B6D4);
  static const Color statusUrgent = Color(0xFFDC2626);
}
