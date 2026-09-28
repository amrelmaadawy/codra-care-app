import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/patient_list_query.dart';
import '../../domain/entities/patient_page_entity.dart';
import '../../domain/repositories/patient_repository.dart';
import '../data_sources/patient_remote_data_source.dart';

class PatientRepositoryImpl implements PatientRepository {
  final PatientRemoteDataSource remoteDataSource;

  const PatientRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PatientPageEntity>> getPatients(
    PatientListQuery query, {
    CancelToken? cancelToken,
  }) async {
    try {
      final result = await remoteDataSource.getPatients(
        query,
        cancelToken: cancelToken,
      );
      return Right(result);
    } catch (e) {
      return Left(FailureMapper.mapExceptionToFailure(e));
    }
  }
}
