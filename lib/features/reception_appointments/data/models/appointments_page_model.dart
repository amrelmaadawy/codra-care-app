import '../../domain/entities/appointment_enums.dart';
import '../../domain/entities/appointment_filters.dart';
import '../../domain/entities/appointments_page_entity.dart';
import 'appointment_model.dart';

class AppointmentsPageModel extends AppointmentsPageEntity {
  const AppointmentsPageModel({
    required super.items,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
    required super.hasMore,
    required super.appliedFilters,
  });

  factory AppointmentsPageModel.fromJson(Map<String, dynamic> json) {
    final itemsList =
        (json['items'] as List<dynamic>?)
            ?.map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final filtersJson = json['applied_filters'] as Map<String, dynamic>? ?? {};

    final statusStr = filtersJson['status'] as String?;
    final appliedFilters = AppointmentFilters(
      date: (filtersJson['date'] as String?) ?? '',
      doctorId: (filtersJson['doctor_id'] as num?)?.toInt(),
      status: statusStr != null
          ? AppointmentStatus.fromString(statusStr)
          : null,
    );

    return AppointmentsPageModel(
      items: itemsList,
      currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
      lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
      perPage: (meta['per_page'] as num?)?.toInt() ?? 20,
      total: (meta['total'] as num?)?.toInt() ?? itemsList.length,
      hasMore: (meta['has_more'] as bool?) ?? false,
      appliedFilters: appliedFilters,
    );
  }
}
