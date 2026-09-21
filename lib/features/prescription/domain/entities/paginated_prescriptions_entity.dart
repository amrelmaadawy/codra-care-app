import 'package:equatable/equatable.dart';
import 'prescription_entity.dart';

class PaginatedPrescriptionsEntity extends Equatable {
  final List<PrescriptionEntity> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedPrescriptionsEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMorePages => currentPage < lastPage;

  @override
  List<Object?> get props => [items, currentPage, lastPage, total];
}
