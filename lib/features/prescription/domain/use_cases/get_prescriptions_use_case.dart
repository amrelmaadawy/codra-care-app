import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/paginated_prescriptions_entity.dart';
import '../repositories/prescription_repository.dart';

class GetPrescriptionsUseCase {
  final PrescriptionRepository repository;

  const GetPrescriptionsUseCase(this.repository);

  Future<Either<Failure, PaginatedPrescriptionsEntity>> call({
    int page = 1,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? isPrinted,
  }) {
    return repository.getPrescriptions(
      page: page,
      search: search,
      dateFrom: dateFrom,
      dateTo: dateTo,
      isPrinted: isPrinted,
    );
  }
}
