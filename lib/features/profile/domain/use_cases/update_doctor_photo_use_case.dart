import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateDoctorPhotoUseCase {
  final ProfileRepository _repository;

  const UpdateDoctorPhotoUseCase(this._repository);

  Future<Either<Failure, DoctorProfileEntity>> call(String filePath) =>
      _repository.updatePhoto(filePath);
}
