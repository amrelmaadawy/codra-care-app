import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateDoctorProfileUseCase {
  final ProfileRepository _repository;

  const UpdateDoctorProfileUseCase(this._repository);

  Future<Either<Failure, DoctorProfileEntity>> call({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  }) =>
      _repository.updateProfile(
        name: name,
        specialization: specialization,
        phone: phone,
        licenseNumber: licenseNumber,
      );
}
