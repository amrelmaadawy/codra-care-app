import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_extensions.dart';

class AppointmentCheckInPrioritySelector extends StatelessWidget {
  final String selectedPriority;
  final bool isSubmitting;
  final ValueChanged<String> onPriorityChanged;

  const AppointmentCheckInPrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.isSubmitting,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = [
      (
        'normal',
        'reception_appointments.priority_normal'.tr(),
        Icons.access_time_rounded,
        context.primaryColor,
      ),
      (
        'urgent',
        'reception_appointments.priority_urgent'.tr(),
        Icons.bolt_rounded,
        AppColors.error,
      ),
      (
        'vip',
        'reception_appointments.priority_vip'.tr(),
        Icons.workspace_premium_rounded,
        const Color(0xFF8B5CF6),
      ),
    ];

    return Row(
      children: priorities.map((p) {
        final selected = selectedPriority == p.$1;
        final accent = p.$4;
        final borderColor = selected
            ? accent
            : context.dividerColor.withValues(alpha: 0.6);
        final bgColor = selected
            ? accent.withValues(alpha: 0.08)
            : context.surfaceColor;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isSubmitting ? null : () => onPriorityChanged(p.$1),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: borderColor,
                      width: selected ? 1.5 : 1.0,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.12),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? Icons.check_circle_rounded : p.$3,
                        size: 15,
                        color: selected ? accent : context.textMutedColor,
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          p.$2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w600,
                            color: selected ? accent : context.textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
