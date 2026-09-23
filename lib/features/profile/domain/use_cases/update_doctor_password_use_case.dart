import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateDoctorPasswordUseCase {
  final ProfileRepository _repository;

  const UpdateDoctorPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) =>
      _repository.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
}
