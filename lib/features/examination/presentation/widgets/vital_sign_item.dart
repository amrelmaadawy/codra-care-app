import 'package:flutter/material.dart';

class VitalSignItem {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const VitalSignItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });
}
