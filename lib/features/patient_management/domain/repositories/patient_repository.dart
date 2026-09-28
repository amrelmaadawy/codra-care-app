import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../entities/patient_list_query.dart';
import '../entities/patient_page_entity.dart';

abstract class PatientRepository {
  Future<Either<Failure, PatientPageEntity>> getPatients(
    PatientListQuery query, {
    CancelToken? cancelToken,
  });
}
