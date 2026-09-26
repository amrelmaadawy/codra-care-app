import 'package:equatable/equatable.dart';

class QueueFilter extends Equatable {
  final String? status;
  final int? doctorId;
  final bool? isPresent;
  final String? search;
  final String? priority;
  final int page;
  final int perPage;

  const QueueFilter({
    this.status,
    this.doctorId,
    this.isPresent,
    this.search,
    this.priority,
    this.page = 1,
    this.perPage = 25,
  });

  QueueFilter copyWith({
    String? Function()? status,
    int? Function()? doctorId,
    bool? Function()? isPresent,
    String? Function()? search,
    String? Function()? priority,
    int? page,
    int? perPage,
  }) {
    return QueueFilter(
      status: status != null ? status() : this.status,
      doctorId: doctorId != null ? doctorId() : this.doctorId,
      isPresent: isPresent != null ? isPresent() : this.isPresent,
      search: search != null ? search() : this.search,
      priority: priority != null ? priority() : this.priority,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (status != null && status!.isNotEmpty) params['status'] = status;
    if (doctorId != null) params['doctor_id'] = doctorId;
    if (isPresent != null) params['is_present'] = isPresent! ? 1 : 0;
    if (search != null && search!.trim().isNotEmpty) {
      params['search'] = search!.trim();
    }
    if (priority != null && priority!.isNotEmpty) params['priority'] = priority;
    return params;
  }

  @override
  List<Object?> get props => [
    status,
    doctorId,
    isPresent,
    search,
    priority,
    page,
    perPage,
  ];
}
