import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return ListView(
          padding: AppSpacing.pagePadding,
          children: [
            _buildProfileHeader(context, user?.name ?? '', user?.email ?? ''),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoCard(context, user),
            const SizedBox(height: AppSpacing.xl),
            _buildLogoutButton(context),
            const SizedBox(height: AppSpacing.xxl),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, String name, String email) {
    return Container(
      padding: AppSpacing.cardPadding,
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
          Container(
            width: AppSizes.avatarLg * 1.3,
            height: AppSizes.avatarLg * 1.3,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              AppIcons.profile,
              color: context.primaryColor,
              size: AppSizes.iconXl * 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            name,
            style: AppTypography.titleLarge.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            email,
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, dynamic user) {
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
          _buildInfoRow(
            context,
            icon: AppIcons.profile,
            label: 'profile.role'.tr(),
            value: user?.role ?? '—',
          ),
          Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.5)),
          _buildInfoRow(
            context,
            icon: AppIcons.clinic,
            label: 'profile.clinic_code'.tr(),
            value: user?.tenantCode ?? '—',
          ),
          Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.5)),
          _buildInfoRow(
            context,
            icon: AppIcons.info,
            label: 'profile.account_type'.tr(),
            value: user?.accountType ?? '—',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
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
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: context.textMutedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _confirmLogout(context),
        borderRadius: AppRadius.buttonRadius,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: AppColors.errorLight.withValues(alpha: 0.4),
            borderRadius: AppRadius.buttonRadius,
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(AppIcons.logout, color: AppColors.error, size: AppSizes.iconSm),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'auth.logout'.tr(),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'auth.logout'.tr(),
            style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'auth.logout_confirmation'.tr(),
            style: AppTypography.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.onPrimary,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthCubit>().logout();
              },
              child: Text('auth.logout'.tr()),
            ),
          ],
        );
      },
    );
  }
}
