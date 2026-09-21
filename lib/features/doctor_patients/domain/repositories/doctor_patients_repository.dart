import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_detail_entity.dart';
import '../entities/patient_list_result_entity.dart';

abstract interface class DoctorPatientsRepository {
  Future<Either<Failure, PatientListResultEntity>> getPatients({
    String? search,
    int page = 1,
  });

  Future<Either<Failure, PatientDetailEntity>> getPatientDetail(int id);
}
