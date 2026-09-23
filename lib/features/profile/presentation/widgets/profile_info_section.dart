import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/doctor_profile_entity.dart';

class ProfileInfoSection extends StatelessWidget {
  final DoctorProfileEntity profile;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;

  const ProfileInfoSection({
    super.key,
    required this.profile,
    required this.onEditProfile,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfoCard(context),
        const SizedBox(height: AppSpacing.lg),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.5),
        ),
        boxShadow: context.primaryShadow,
      ),
      child: Column(
        children: [
          _buildRow(
            context,
            icon: Icons.badge_outlined,
            label: 'profile.name'.tr(),
            value: profile.name,
          ),
          _buildDivider(context),
          _buildRow(
            context,
            icon: Icons.medical_services_outlined,
            label: 'profile.specialization'.tr(),
            value: profile.specialization ?? '—',
          ),
          _buildDivider(context),
          _buildRow(
            context,
            icon: Icons.phone_outlined,
            label: 'profile.phone'.tr(),
            value: profile.phone ?? '—',
          ),
          _buildDivider(context),
          _buildRow(
            context,
            icon: Icons.verified_user_outlined,
            label: 'profile.license_number'.tr(),
            value: profile.licenseNumber ?? '—',
          ),
          if (profile.clinicCode != null && profile.clinicCode!.isNotEmpty) ...[
            _buildDivider(context),
            _buildRow(
              context,
              icon: AppIcons.clinic,
              label: 'profile.clinic_code'.tr(),
              value: profile.clinicCode!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconMd, color: context.primaryColor),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(color: context.textColor),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                color: context.textMutedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.dividerColor.withValues(alpha: 0.5),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onEditProfile,
          icon: const Icon(Icons.edit_outlined, size: AppSizes.iconSm),
          label: Text('profile.edit_info'.tr()),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.primaryColor,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(double.infinity, 48),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.buttonRadius,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: onChangePassword,
          icon: const Icon(Icons.lock_reset_outlined, size: AppSizes.iconSm),
          label: Text('profile.change_password'.tr()),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.primaryColor,
            side: BorderSide(color: context.primaryColor.withValues(alpha: 0.5)),
            minimumSize: const Size(double.infinity, 48),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.buttonRadius,
            ),
          ),
        ),
      ],
    );
  }
}
