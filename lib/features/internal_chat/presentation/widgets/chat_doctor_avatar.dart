import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class ChatDoctorAvatar extends StatelessWidget {
  final String name;
  final bool isActive;
  final double size;

  const ChatDoctorAvatar({
    super.key,
    required this.name,
    this.isActive = true,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name.characters.first : '?';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isActive
            ? context.primaryColor.withValues(alpha: 0.12)
            : context.disabledColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTypography.titleMedium.copyWith(
            color: isActive ? context.primaryColor : context.disabledColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
