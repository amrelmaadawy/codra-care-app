import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_detail_entity.dart';
import '../repositories/doctor_patients_repository.dart';

class GetPatientDetailUseCase {
  final DoctorPatientsRepository _repository;

  const GetPatientDetailUseCase(this._repository);

  Future<Either<Failure, PatientDetailEntity>> call(int id) {
    return _repository.getPatientDetail(id);
  }
}
