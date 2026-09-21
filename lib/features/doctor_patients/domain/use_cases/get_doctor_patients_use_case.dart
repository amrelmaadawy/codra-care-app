import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_list_result_entity.dart';
import '../repositories/doctor_patients_repository.dart';

class GetDoctorPatientsUseCase {
  final DoctorPatientsRepository _repository;

  const GetDoctorPatientsUseCase(this._repository);

  Future<Either<Failure, PatientListResultEntity>> call({
    String? search,
    int page = 1,
  }) {
    return _repository.getPatients(search: search, page: page);
  }
}
