import '../../domain/entities/queue_doctor_entity.dart';

class QueueDoctorModel extends QueueDoctorEntity {
  const QueueDoctorModel({
    required super.id,
    required super.name,
    super.count,
  });

  factory QueueDoctorModel.fromJson(Map<String, dynamic> json) {
    return QueueDoctorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
    };
  }
}
