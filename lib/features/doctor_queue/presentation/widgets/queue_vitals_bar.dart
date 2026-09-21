import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueueVitalsBar extends StatelessWidget {
  final Map<String, dynamic> vitalSigns;

  const QueueVitalsBar({super.key, required this.vitalSigns});

  @override
  Widget build(BuildContext context) {
    final bp = vitalSigns['blood_pressure'] ?? vitalSigns['bp'];
    final pulse = vitalSigns['pulse'] ?? vitalSigns['heart_rate'];
    final temp = vitalSigns['temperature'] ?? vitalSigns['temp'];

    final pills = <Widget>[];

    if (bp != null) {
      pills.add(_buildVitalPill(
        icon: Icons.speed_rounded,
        label: '$bp',
        iconColor: context.primaryColor,
        bgColor: context.primaryColor.withValues(alpha: 0.08),
      ));
    }

    if (pulse != null) {
      pills.add(_buildVitalPill(
        icon: Icons.monitor_heart_outlined,
        label: '$pulse bpm',
        iconColor: AppColors.error,
        bgColor: AppColors.error.withValues(alpha: 0.08),
      ));
    }

    if (temp != null) {
      final tempVal = (temp is num) ? temp.toDouble() : double.tryParse('$temp');
      final isHigh = tempVal != null && tempVal >= 38.0;
      pills.add(_buildVitalPill(
        icon: Icons.thermostat_rounded,
        label: '$temp°C',
        iconColor: isHigh ? AppColors.statusUrgent : AppColors.warning,
        bgColor: (isHigh ? AppColors.statusUrgent : AppColors.warning).withValues(alpha: 0.09),
      ));
    }

    if (pills.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: pills,
      ),
    );
  }

  Widget _buildVitalPill({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}
