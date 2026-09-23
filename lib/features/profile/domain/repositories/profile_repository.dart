import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, DoctorProfileEntity>> getProfile();

  Future<Either<Failure, DoctorProfileEntity>> updateProfile({
    required String name,
    String? specialization,
    String? phone,
    String? licenseNumber,
  });

  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });

  Future<Either<Failure, DoctorProfileEntity>> updatePhoto(String filePath);
}
