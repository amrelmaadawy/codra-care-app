import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_list_query.dart';
import '../entities/patient_page_entity.dart';
import '../repositories/patient_repository.dart';

class GetPatientsUseCase {
  final PatientRepository repository;

  const GetPatientsUseCase(this.repository);

  Future<Either<Failure, PatientPageEntity>> call(
    PatientListQuery query, {
    CancelToken? cancelToken,
  }) {
    return repository.getPatients(query, cancelToken: cancelToken);
  }
}
