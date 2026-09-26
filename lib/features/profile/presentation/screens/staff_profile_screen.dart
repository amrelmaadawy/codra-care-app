import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../auth/presentation/cubits/auth_state.dart';
import '../../../shell/presentation/widgets/app_drawer_avatar.dart';
import '../../../shell/presentation/widgets/shell_logout_dialog.dart';
import '../widgets/doctor_profile_app_bar.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  String _formatRole(String role, String accountType) {
    final keyType = accountType.isNotEmpty ? accountType : role;
    if (keyType.isEmpty) return '';
    final trKey = 'shell.roles.${keyType.toLowerCase()}';
    final translated = trKey.tr();
    if (translated != trKey) return translated;
    return role.isNotEmpty ? role.toUpperCase() : accountType.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: const DoctorProfileAppBar(),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }
          final user = state.user;
          final roleTitle = _formatRole(user.role, user.accountType);

          return ListView(
            padding: AppSpacing.pagePadding,
            children: [
              _buildHeaderCard(context, user, roleTitle),
              const SizedBox(height: AppSpacing.lg),
              _buildInfoCard(context, user, roleTitle),
              const SizedBox(height: AppSpacing.xl),
              _buildLogoutButton(context),
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    UserEntity user,
    String roleTitle,
  ) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
        boxShadow: context.primaryShadow,
      ),
      child: Column(
        children: [
          AppDrawerAvatar(name: user.name),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.name.isNotEmpty ? user.name : '—',
            style: AppTypography.titleLarge.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (roleTitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.buttonRadius,
              ),
              child: Text(
                roleTitle,
                style: AppTypography.labelMedium.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    UserEntity user,
    String roleTitle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5)),
        boxShadow: context.primaryShadow,
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.person_outline,
            label: 'profile.name'.tr(),
            value: user.name,
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.email_outlined,
            label: 'profile.email'.tr(),
            value: user.email,
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.phone_outlined,
            label: 'profile.phone'.tr(),
            value: user.phone ?? '—',
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.local_hospital_outlined,
            label: 'profile.clinic_code'.tr(),
            value: user.tenantCode,
          ),
          if (roleTitle.isNotEmpty) ...[
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: Icons.badge_outlined,
              label: 'profile.role'.tr(),
              value: roleTitle,
            ),
          ],
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
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconMd, color: context.primaryColor),
          const SizedBox(width: AppSpacing.md),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: context.textMutedColor,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.w500,
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
      color: context.dividerColor.withValues(alpha: 0.3),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => ShellLogoutDialog.show(context),
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: Text(
          'auth.logout'.tr(),
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.buttonRadius,
          ),
        ),
      ),
    );
  }
}
