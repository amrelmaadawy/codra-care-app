import 'package:equatable/equatable.dart';

class ReceptionDoctorSummaryEntity extends Equatable {
  final int id;
  final String name;
  final int todayCount;

  const ReceptionDoctorSummaryEntity({
    required this.id,
    required this.name,
    required this.todayCount,
  });

  @override
  List<Object?> get props => [id, name, todayCount];
}
