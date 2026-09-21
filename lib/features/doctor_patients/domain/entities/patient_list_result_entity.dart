import 'package:equatable/equatable.dart';
import 'patient_summary_entity.dart';

class PatientListResultEntity extends Equatable {
  final List<PatientSummaryEntity> items;
  final int total;
  final int currentPage;
  final int lastPage;
  final int? totalPatientsStat;

  const PatientListResultEntity({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.totalPatientsStat,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
    items,
    total,
    currentPage,
    lastPage,
    totalPatientsStat,
  ];
}
