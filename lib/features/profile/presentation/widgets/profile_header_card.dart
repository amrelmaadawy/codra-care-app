import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_shimmer_box.dart';
import '../../domain/entities/doctor_profile_entity.dart';

class ProfileHeaderCard extends StatelessWidget {
  final DoctorProfileEntity profile;
  final bool isUploadingPhoto;
  final ValueChanged<String> onPhotoSelected;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    required this.isUploadingPhoto,
    required this.onPhotoSelected,
  });

  static const double _avatarSize = 88.0;

  @override
  Widget build(BuildContext context) {
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
          _buildAvatarStack(context),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.name.isNotEmpty ? profile.name : '—',
            style: AppTypography.titleLarge.copyWith(
              color: context.textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (profile.specialization != null &&
              profile.specialization!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: AppRadius.chipRadius,
              ),
              child: Text(
                profile.specialization!,
                style: AppTypography.labelMedium.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (profile.email != null && profile.email!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              profile.email!,
              style: AppTypography.bodySmall.copyWith(
                color: context.textMutedColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatarStack(BuildContext context) {
    final hasPhoto = profile.photoUrl != null && profile.photoUrl!.isNotEmpty;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: _avatarSize,
          height: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.primaryColor.withValues(alpha: 0.3),
              width: 3,
            ),
          ),
          child: ClipOval(
            child: isUploadingPhoto
                ? const AppShimmer(
                    child: AppShimmerBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : hasPhoto
                    ? CachedNetworkImage(
                        imageUrl: profile.photoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => const AppShimmer(
                          child: AppShimmerBox(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        errorWidget: (_, _, _) => _buildFallbackAvatar(context),
                      )
                    : _buildFallbackAvatar(context),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: context.primaryColor,
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              onTap: isUploadingPhoto ? null : () => _showPickerSheet(context),
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.xs),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.onPrimary,
                  size: AppSizes.iconSm,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    return Container(
      color: context.primaryColor.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Icon(
        AppIcons.profile,
        color: context.primaryColor,
        size: AppSizes.iconXl * 1.3,
      ),
    );
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'profile.choose_source'.tr(),
                style: AppTypography.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined, color: context.primaryColor),
                title: Text('profile.camera'.tr()),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library_outlined, color: context.primaryColor),
                title: Text('profile.gallery'.tr()),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (file != null) onPhotoSelected(file.path);
  }
}
