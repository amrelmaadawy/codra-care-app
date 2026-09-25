import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/reception_dashboard_entity.dart';
import '../repositories/reception_dashboard_repository.dart';

class GetReceptionDashboardParams extends Equatable {
  final int? doctorId;

  const GetReceptionDashboardParams({this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

class GetReceptionDashboardUseCase {
  final ReceptionDashboardRepository _repository;

  const GetReceptionDashboardUseCase(this._repository);

  Future<Either<Failure, ReceptionDashboardEntity>> call([
    GetReceptionDashboardParams params = const GetReceptionDashboardParams(),
  ]) {
    return _repository.getDashboard(doctorId: params.doctorId);
  }
}
