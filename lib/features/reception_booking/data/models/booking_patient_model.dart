import '../../domain/entities/booking_patient_entity.dart';

class BookingPatientModel extends BookingPatientEntity {
  const BookingPatientModel({
    required super.id,
    super.patientCode,
    required super.fullName,
    required super.phone,
    super.gender,
    super.age,
    super.address,
  });

  factory BookingPatientModel.fromJson(Map<String, dynamic> json) {
    return BookingPatientModel(
      id: json['id'] as int,
      patientCode: json['patient_code'] as String?,
      fullName: (json['full_name'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      gender: json['gender'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patient_code': patientCode,
    'full_name': fullName,
    'phone': phone,
    'gender': gender,
    'age': age,
    'address': address,
  };
}
