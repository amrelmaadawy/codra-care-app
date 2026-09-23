import 'package:equatable/equatable.dart';

class DoctorProfileEntity extends Equatable {
  final int id;
  final int? userId;
  final String name;
  final String? specialization;
  final String? title;
  final String? phone;
  final String? email;
  final String? licenseNumber;
  final String? photoUrl;
  final String? clinicCode;
  final bool isActive;

  const DoctorProfileEntity({
    required this.id,
    this.userId,
    required this.name,
    this.specialization,
    this.title,
    this.phone,
    this.email,
    this.licenseNumber,
    this.photoUrl,
    this.clinicCode,
    this.isActive = true,
  });

  DoctorProfileEntity copyWith({
    int? id,
    int? userId,
    String? name,
    String? specialization,
    String? title,
    String? phone,
    String? email,
    String? licenseNumber,
    String? photoUrl,
    String? clinicCode,
    bool? isActive,
  }) {
    return DoctorProfileEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      title: title ?? this.title,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      clinicCode: clinicCode ?? this.clinicCode,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        specialization,
        title,
        phone,
        email,
        licenseNumber,
        photoUrl,
        clinicCode,
        isActive,
      ];
}
