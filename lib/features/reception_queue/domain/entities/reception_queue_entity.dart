import 'package:equatable/equatable.dart';
import 'queue_doctor_entity.dart';
import 'queue_summary_entity.dart';
import 'reception_queue_item_entity.dart';

class ReceptionQueueEntity extends Equatable {
  final List<ReceptionQueueItemEntity> items;
  final QueueSummaryEntity summary;
  final List<QueueDoctorEntity> doctors;
  final int total;
  final int page;
  final int perPage;
  final int lastPage;

  const ReceptionQueueEntity({
    this.items = const [],
    this.summary = const QueueSummaryEntity(),
    this.doctors = const [],
    this.total = 0,
    this.page = 1,
    this.perPage = 25,
    this.lastPage = 1,
  });

  bool get hasMore => page < lastPage;

  @override
  List<Object?> get props => [
    items,
    summary,
    doctors,
    total,
    page,
    perPage,
    lastPage,
  ];
}
