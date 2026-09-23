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
import '../../domain/entities/doctor_profile_entity.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  final DoctorProfileEntity profile;
  final bool isLoading;
  final Future<bool> Function({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) onSave;

  const ProfileEditBottomSheet({
    super.key,
    required this.profile,
    required this.isLoading,
    required this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    required DoctorProfileEntity profile,
    required bool isLoading,
    required Future<bool> Function({
      required String name,
      String? specialization,
      String? phone,
      String? licenseNumber,
    }) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => ProfileEditBottomSheet(
        profile: profile,
        isLoading: isLoading,
        onSave: onSave,
      ),
    );
  }

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _specController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _specController = TextEditingController(text: widget.profile.specialization ?? '');
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _licenseController = TextEditingController(text: widget.profile.licenseNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    final success = await widget.onSave(
      name: _nameController.text.trim(),
      specialization: _specController.text.trim().isEmpty ? null : _specController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      licenseNumber: _licenseController.text.trim().isEmpty ? null : _licenseController.text.trim(),
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
                    'profile.edit_info'.tr(),
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
                controller: _nameController,
                label: 'profile.name'.tr(),
                hint: 'profile.name_hint'.tr(),
                icon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'profile.validation_name_required'.tr();
                  }
                  return val.trim().length < 3 ? 'profile.validation_name_min'.tr() : null;
                },
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _specController,
                label: 'profile.specialization'.tr(),
                hint: 'profile.specialization_hint'.tr(),
                icon: Icons.medical_services_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _phoneController,
                label: 'profile.phone'.tr(),
                hint: 'profile.phone_hint'.tr(),
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildField(
                controller: _licenseController,
                label: 'profile.license_number'.tr(),
                hint: 'profile.license_number_hint'.tr(),
                icon: Icons.verified_user_outlined,
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
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: AppSizes.iconMd),
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
        'profile.save_info'.tr(),
        style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
