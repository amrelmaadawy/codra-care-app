import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_prescriptions_entity.dart';
import '../entities/prescription_context_entity.dart';
import '../entities/prescription_entity.dart';

abstract class PrescriptionRepository {
  Future<Either<Failure, PaginatedPrescriptionsEntity>> getPrescriptions({
    int page = 1,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? isPrinted,
  });

  Future<Either<Failure, PrescriptionContextEntity>> getCreateContext({
    int? visitId,
    int? patientId,
  });

  Future<Either<Failure, PrescriptionEntity>> getPrescriptionDetail(int id);

  Future<Either<Failure, PrescriptionEntity>> createPrescription({
    required int patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  });

  Future<Either<Failure, PrescriptionEntity>> updatePrescription({
    required int id,
    int? patientId,
    int? visitId,
    String? notes,
    required List<Map<String, dynamic>> items,
  });

  Future<Either<Failure, void>> deletePrescription(int id);

  Future<Either<Failure, PrescriptionEntity>> copyPrescription(int id);

  Future<Either<Failure, void>> markPrinted(int id);
}
