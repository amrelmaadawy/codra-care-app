import 'package:equatable/equatable.dart';

class PatientProfileInfoEntity extends Equatable {
  final int id;
  final String name;
  final String code;
  final String? phone;
  final String? gender;
  final String? genderLabel;
  final int? age;
  final String? bloodType;
  final String? dateOfBirth;
  final String? nationalId;
  final String? address;

  const PatientProfileInfoEntity({
    required this.id,
    required this.name,
    required this.code,
    this.phone,
    this.gender,
    this.genderLabel,
    this.age,
    this.bloodType,
    this.dateOfBirth,
    this.nationalId,
    this.address,
  });

  bool get isFemale => gender == 'female';
  bool get isMale => gender == 'male';

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    phone,
    gender,
    genderLabel,
    age,
    bloodType,
    dateOfBirth,
    nationalId,
    address,
  ];
}
