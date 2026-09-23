import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppDrawerAvatar extends StatelessWidget {
  final String name;

  const AppDrawerAvatar({super.key, required this.name});

  String _extractInitials(String rawName) {
    var clean = rawName.trim();
    clean = clean.replaceFirst(
      RegExp(r'^(د\.|د/|دكتور|Dr\.|Doctor)\s*', caseSensitive: false),
      '',
    ).trim();
    if (clean.isEmpty) return 'د';
    final parts = clean.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      final first = parts[0][0];
      var second = parts[1];
      if (second.startsWith('ال') && second.length > 2) {
        second = second.substring(2);
      }
      return '$first.${second[0]}';
    }
    return parts[0][0];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.primaryColor,
                AppColors.primaryLight,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: context.surfaceColor,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.22),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              _extractInitials(name),
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 0,
          end: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              border: Border.all(
                color: context.surfaceColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
