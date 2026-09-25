import 'package:equatable/equatable.dart';

class BookingPatientEntity extends Equatable {
  final int id;
  final String? patientCode;
  final String fullName;
  final String phone;
  final String? gender;
  final int? age;
  final String? address;

  const BookingPatientEntity({
    required this.id,
    this.patientCode,
    required this.fullName,
    required this.phone,
    this.gender,
    this.age,
    this.address,
  });

  @override
  List<Object?> get props => [
    id,
    patientCode,
    fullName,
    phone,
    gender,
    age,
    address,
  ];
}
