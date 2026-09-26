import 'package:equatable/equatable.dart';

class GetFollowUpsParams extends Equatable {
  final int? doctorId;
  final String? urgency;
  final String? search;
  final String? startDate;
  final String? endDate;
  final int page;
  final int perPage;

  const GetFollowUpsParams({
    this.doctorId,
    this.urgency,
    this.search,
    this.startDate,
    this.endDate,
    this.page = 1,
    this.perPage = 15,
  });

  Map<String, dynamic> toQueryMap() {
    final map = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };
    if (doctorId != null) map['doctor_id'] = doctorId;
    if (urgency != null && urgency!.isNotEmpty) map['urgency'] = urgency;
    if (search != null && search!.trim().isNotEmpty) {
      map['search'] = search!.trim();
    }
    if (startDate != null && startDate!.isNotEmpty) {
      map['start_date'] = startDate;
    }
    if (endDate != null && endDate!.isNotEmpty) {
      map['end_date'] = endDate;
    }
    return map;
  }

  GetFollowUpsParams copyWith({
    int? doctorId,
    String? urgency,
    String? search,
    String? startDate,
    String? endDate,
    int? page,
    int? perPage,
    bool clearDoctorId = false,
    bool clearUrgency = false,
    bool clearSearch = false,
    bool clearDates = false,
  }) {
    return GetFollowUpsParams(
      doctorId: clearDoctorId ? null : (doctorId ?? this.doctorId),
      urgency: clearUrgency ? null : (urgency ?? this.urgency),
      search: clearSearch ? null : (search ?? this.search),
      startDate: clearDates ? null : (startDate ?? this.startDate),
      endDate: clearDates ? null : (endDate ?? this.endDate),
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  @override
  List<Object?> get props => [
        doctorId,
        urgency,
        search,
        startDate,
        endDate,
        page,
        perPage,
      ];
}
