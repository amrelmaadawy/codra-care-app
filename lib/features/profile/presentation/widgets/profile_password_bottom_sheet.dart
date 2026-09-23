import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';

class ProfilePasswordBottomSheet extends StatefulWidget {
  final bool isLoading;
  final Future<bool> Function({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) onSave;

  const ProfilePasswordBottomSheet({
    super.key,
    required this.isLoading,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isLoading,
    required Future<bool> Function({
      required String currentPassword,
      required String newPassword,
      required String confirmPassword,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => ProfilePasswordBottomSheet(
        isLoading: isLoading,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProfilePasswordBottomSheet> createState() =>
      _ProfilePasswordBottomSheetState();
}

class _ProfilePasswordBottomSheetState
    extends State<ProfilePasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    final success = await widget.onSave(
      currentPassword: _currentPassController.text,
      newPassword: _newPassController.text,
      confirmPassword: _confirmPassController.text,
    );
    if (mounted) {
      setState(() => _isSubmitting = false);
      if (success) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: bottomInset + AppSpacing.lg,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'profile.change_password'.tr(),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.textColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _currentPassController,
                label: 'profile.current_password'.tr(),
                obscure: _obscureCurrent,
                onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                validator: (val) => val == null || val.isEmpty
                    ? 'profile.validation_current_pass_required'.tr()
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _newPassController,
                label: 'profile.new_password'.tr(),
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'profile.validation_new_pass_required'.tr();
                  }
                  return val.length < 8 ? 'profile.validation_pass_min'.tr() : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _confirmPassController,
                label: 'profile.confirm_password'.tr(),
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (val) => val != _newPassController.text
                    ? 'profile.validation_pass_not_match'.tr()
                    : null,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, size: AppSizes.iconMd),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: AppSizes.iconMd,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: context.surfaceVariantColor.withValues(alpha: 0.3),
        border: const OutlineInputBorder(borderRadius: AppRadius.buttonRadius),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    if (_isSubmitting || widget.isLoading) {
      return const AppShimmer(
        child: AppShimmerBox(width: double.infinity, height: 48),
      );
    }

    return ElevatedButton(
      onPressed: _submit,
      style: ElevatedButton.styleFrom(
        backgroundColor: context.primaryColor,
        foregroundColor: AppColors.onPrimary,
        minimumSize: const Size(double.infinity, 48),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
      child: Text(
        'profile.save_password'.tr(),
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
