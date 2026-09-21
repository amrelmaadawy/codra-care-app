import 'package:flutter/material.dart';

abstract final class AppShadows {
  static List<BoxShadow> get card => [
    BoxShadow(
      color: const Color(0xFF006B6B).withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: const Color(0xFF006B6B).withValues(alpha: 0.12),
      blurRadius: 24,
      offset: const Offset(0, 6),
    ),
  ];
}
