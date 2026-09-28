import 'package:equatable/equatable.dart';
import 'patient_list_entity.dart';

class PatientPageEntity extends Equatable {
  final List<PatientListEntity> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;

  const PatientPageEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [
    items,
    currentPage,
    lastPage,
    perPage,
    total,
    hasMore,
  ];
}
