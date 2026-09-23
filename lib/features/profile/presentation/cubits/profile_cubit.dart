import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_doctor_profile_use_case.dart';
import '../../domain/use_cases/update_doctor_password_use_case.dart';
import '../../domain/use_cases/update_doctor_photo_use_case.dart';
import '../../domain/use_cases/update_doctor_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetDoctorProfileUseCase getDoctorProfileUseCase;
  final UpdateDoctorProfileUseCase updateDoctorProfileUseCase;
  final UpdateDoctorPasswordUseCase updateDoctorPasswordUseCase;
  final UpdateDoctorPhotoUseCase updateDoctorPhotoUseCase;

  ProfileCubit({
    required this.getDoctorProfileUseCase,
    required this.updateDoctorProfileUseCase,
    required this.updateDoctorPasswordUseCase,
    required this.updateDoctorPhotoUseCase,
  }) : super(const ProfileInitial());

  Future<void> loadProfile({bool showLoading = true}) async {
    if (showLoading || state is! ProfileLoaded) {
      emit(const ProfileLoading());
    }

    final result = await getDoctorProfileUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<bool> updateInfo({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) async {
    if (state is! ProfileLoaded) return false;
    final current = state as ProfileLoaded;

    emit(current.copyWith(isActionLoading: true));

    final result = await updateDoctorProfileUseCase(
      name: name,
      specialization: specialization,
      phone: phone,
      licenseNumber: licenseNumber,
    );

    return result.fold(
      (failure) {
        emit(current.copyWith(
          isActionLoading: false,
          errorMessage: failure.message,
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return false;
      },
      (updatedProfile) {
        emit(current.copyWith(
          profile: updatedProfile,
          isActionLoading: false,
          successMessage: 'profile.update_success',
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return true;
      },
    );
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (state is! ProfileLoaded) return false;
    final current = state as ProfileLoaded;

    emit(current.copyWith(isActionLoading: true));

    final result = await updateDoctorPasswordUseCase(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      (failure) {
        emit(current.copyWith(
          isActionLoading: false,
          errorMessage: failure.message,
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return false;
      },
      (_) {
        emit(current.copyWith(
          isActionLoading: false,
          successMessage: 'profile.password_success',
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return true;
      },
    );
  }

  Future<bool> uploadPhoto(String filePath) async {
    if (state is! ProfileLoaded) return false;
    final current = state as ProfileLoaded;

    emit(current.copyWith(isActionLoading: true));

    final result = await updateDoctorPhotoUseCase(filePath);

    return result.fold(
      (failure) {
        emit(current.copyWith(
          isActionLoading: false,
          errorMessage: failure.message,
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return false;
      },
      (updatedProfile) {
        emit(current.copyWith(
          profile: updatedProfile,
          isActionLoading: false,
          successMessage: 'profile.photo_success',
          actionTimestamp: DateTime.now().millisecondsSinceEpoch,
        ));
        return true;
      },
    );
  }
}
