import 'package:equatable/equatable.dart';

class PatientStatsEntity extends Equatable {
  final int visitsCount;
  final String? firstVisit;
  final String? lastVisit;
  final int prescriptionsCount;

  const PatientStatsEntity({
    required this.visitsCount,
    this.firstVisit,
    this.lastVisit,
    required this.prescriptionsCount,
  });

  @override
  List<Object?> get props => [
    visitsCount,
    firstVisit,
    lastVisit,
    prescriptionsCount,
  ];
}
