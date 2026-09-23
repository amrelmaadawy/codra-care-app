import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_state.dart';
import '../widgets/doctor_profile_app_bar.dart';
import '../widgets/profile_edit_bottom_sheet.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_info_section.dart';
import '../widgets/profile_password_bottom_sheet.dart';
import '../widgets/profile_shimmer.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: const DoctorProfileAppBar(),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (prev, curr) {
          if (curr is ProfileLoaded && prev is ProfileLoaded) {
            return curr.actionTimestamp != prev.actionTimestamp;
          }
          return false;
        },
        listener: (context, state) {
          if (state is ProfileLoaded) {
            if (state.successMessage != null) {
              AppSnackBar.showSuccess(context, state.successMessage!);
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const ProfileShimmer();
          }

          if (state is ProfileError) {
            return AppErrorWidget(
              failure: state.failure,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          if (state is ProfileLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<ProfileCubit>().loadProfile(showLoading: false),
              child: ListView(
                padding: AppSpacing.pagePadding,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ProfileHeaderCard(
                    profile: state.profile,
                    isUploadingPhoto: state.isActionLoading,
                    onPhotoSelected: (path) =>
                        context.read<ProfileCubit>().uploadPhoto(path),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ProfileInfoSection(
                    profile: state.profile,
                    onEditProfile: () => _openEditSheet(context, state),
                    onChangePassword: () => _openPasswordSheet(context, state),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _openEditSheet(BuildContext context, ProfileLoaded state) {
    final cubit = context.read<ProfileCubit>();
    ProfileEditBottomSheet.show(
      context,
      profile: state.profile,
      isLoading: state.isActionLoading,
      onSave: ({
        required name,
        specialization,
        phone,
        licenseNumber,
      }) =>
          cubit.updateInfo(
        name: name,
        specialization: specialization,
        phone: phone,
        licenseNumber: licenseNumber,
      ),
    );
  }

  void _openPasswordSheet(BuildContext context, ProfileLoaded state) {
    final cubit = context.read<ProfileCubit>();
    ProfilePasswordBottomSheet.show(
      context,
      isLoading: state.isActionLoading,
      onSave: ({
        required currentPassword,
        required newPassword,
        required confirmPassword,
      }) =>
          cubit.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }
}
