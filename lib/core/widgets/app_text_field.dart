import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../theme/theme_extensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelKey;
  final String? hintKey;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final int maxLines;

  const AppTextField({
    super.key,
    this.controller,
    this.labelKey,
    this.hintKey,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      enabled: enabled,
      maxLines: maxLines,
      style: AppTypography.bodyMedium.copyWith(color: context.textColor),
      decoration: InputDecoration(
        labelText: labelKey?.tr(),
        hintText: hintKey?.tr(),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                size: AppSizes.iconMd,
                color: context.textMutedColor,
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: context.surfaceVariantColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: context.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: context.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: context.primaryColor, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.buttonRadius,
          borderSide: BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
