import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class QueueAppBarIconButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry margin;

  const QueueAppBarIconButton({
    super.key,
    required this.icon,
    this.tooltip,
    this.onPressed,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        margin: margin,
        decoration: BoxDecoration(
          color: context.surfaceVariantColor.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.dividerColor.withValues(alpha: 0.25)),
        ),
        child: IconButton(
          icon: Icon(icon, size: 20, color: context.textColor),
          tooltip: tooltip,
          padding: EdgeInsets.zero,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
