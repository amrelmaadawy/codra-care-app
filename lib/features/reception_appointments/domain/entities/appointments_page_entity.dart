import 'package:equatable/equatable.dart';
import 'appointment_entity.dart';
import 'appointment_filters.dart';

class AppointmentsPageEntity extends Equatable {
  final List<AppointmentEntity> items;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final bool hasMore;
  final AppointmentFilters appliedFilters;

  const AppointmentsPageEntity({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.hasMore,
    required this.appliedFilters,
  });

  AppointmentsPageEntity append(AppointmentsPageEntity more) {
    return AppointmentsPageEntity(
      items: [...items, ...more.items],
      currentPage: more.currentPage,
      lastPage: more.lastPage,
      perPage: more.perPage,
      total: more.total,
      hasMore: more.hasMore,
      appliedFilters: more.appliedFilters,
    );
  }

  @override
  List<Object?> get props => [
    items,
    currentPage,
    lastPage,
    perPage,
    total,
    hasMore,
    appliedFilters,
  ];
}
