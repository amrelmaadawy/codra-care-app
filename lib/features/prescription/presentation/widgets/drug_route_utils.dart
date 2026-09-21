import 'package:flutter/material.dart';

abstract final class DrugRouteUtils {
  static const Map<String, String> defaultRoutes = {
    'oral': 'فموي',
    'topical': 'موضعي',
    'iv': 'وريدي (IV)',
    'im': 'عضلي (IM)',
    'inhalation': 'استنشاق',
    'drops': 'قطرات',
    'sublingual': 'تحت اللسان',
    'rectal': 'شرجي',
    'other': 'أخرى',
  };

  static IconData iconForRoute(String key) {
    return switch (key) {
      'oral' => Icons.medication_rounded,
      'topical' => Icons.healing_rounded,
      'iv' => Icons.water_drop_rounded,
      'im' => Icons.vaccines_rounded,
      'inhalation' => Icons.air_rounded,
      'drops' => Icons.opacity_rounded,
      'sublingual' => Icons.medical_services_rounded,
      'rectal' => Icons.medical_information_rounded,
      _ => Icons.circle_outlined,
    };
  }
}
