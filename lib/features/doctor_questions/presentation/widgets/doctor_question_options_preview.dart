import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';

class DoctorQuestionOptionsPreview extends StatelessWidget {
  final List<String> options;

  const DoctorQuestionOptionsPreview({
    super.key,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    final previewList = options.take(3).toList();
    final remaining = options.length - previewList.length;

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        ...previewList.map(
          (opt) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: context.surfaceVariantColor.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              opt,
              style: AppTypography.caption.copyWith(
                fontSize: 11,
                color: context.textSecondaryColor,
              ),
            ),
          ),
        ),
        if (remaining > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              '+$remaining',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: context.primaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
