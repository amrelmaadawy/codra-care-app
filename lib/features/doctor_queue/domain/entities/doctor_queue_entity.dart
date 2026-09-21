import 'package:equatable/equatable.dart';
import 'queue_patient_entity.dart';
import 'queue_summary_entity.dart';

class DoctorQueueEntity extends Equatable {
  final List<QueuePatientEntity> items;
  final QueueSummaryEntity summary;

  const DoctorQueueEntity({
    required this.items,
    required this.summary,
  });

  const DoctorQueueEntity.empty()
      : items = const [],
        summary = const QueueSummaryEntity.empty();

  @override
  List<Object?> get props => [items, summary];
}
