import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service_option_entity.dart';
import '../repositories/reception_payments_repository.dart';

class GetServiceOptionsUseCase {
  final ReceptionPaymentsRepository repository;

  const GetServiceOptionsUseCase(this.repository);

  Future<Either<Failure, List<ServiceOptionEntity>>> call(
    int appointmentId, {
    String? search,
    int? page,
  }) {
    return repository.getServiceOptions(
      appointmentId,
      search: search,
      page: page,
    );
  }
}
