import 'package:equatable/equatable.dart';

class DoctorLeaveDayEntity extends Equatable {
  final int id;
  final String leaveDate;
  final String? formattedDate;
  final String? dayName;
  final String? reason;
  final bool notifiedReception;
  final String? createdAt;

  const DoctorLeaveDayEntity({
    required this.id,
    required this.leaveDate,
    this.formattedDate,
    this.dayName,
    this.reason,
    this.notifiedReception = true,
    this.createdAt,
  });

  DateTime? get parsedDate => DateTime.tryParse(leaveDate);

  @override
  List<Object?> get props => [
        id,
        leaveDate,
        formattedDate,
        dayName,
        reason,
        notifiedReception,
        createdAt,
      ];
}
