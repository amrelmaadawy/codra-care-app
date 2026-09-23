import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/doctor_profile_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final DoctorProfileEntity profile;
  final bool isActionLoading;
  final String? successMessage;
  final String? errorMessage;
  final int actionTimestamp;

  const ProfileLoaded({
    required this.profile,
    this.isActionLoading = false,
    this.successMessage,
    this.errorMessage,
    this.actionTimestamp = 0,
  });

  ProfileLoaded copyWith({
    DoctorProfileEntity? profile,
    bool? isActionLoading,
    String? successMessage,
    String? errorMessage,
    int? actionTimestamp,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      successMessage: successMessage,
      errorMessage: errorMessage,
      actionTimestamp: actionTimestamp ?? this.actionTimestamp,
    );
  }

  @override
  List<Object?> get props => [
        profile,
        isActionLoading,
        successMessage,
        errorMessage,
        actionTimestamp,
      ];
}

final class ProfileError extends ProfileState {
  final Failure failure;

  const ProfileError(this.failure);

  @override
  List<Object?> get props => [failure];
}
