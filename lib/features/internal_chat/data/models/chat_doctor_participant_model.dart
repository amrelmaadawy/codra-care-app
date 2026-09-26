import '../../domain/entities/chat_doctor_participant_entity.dart';

class ChatDoctorParticipantModel extends ChatDoctorParticipantEntity {
  const ChatDoctorParticipantModel({
    required super.id,
    required super.name,
    super.specialization,
    super.title,
    super.photoUrl,
    super.isActive = true,
  });

  factory ChatDoctorParticipantModel.fromJson(Map<String, dynamic> json) {
    return ChatDoctorParticipantModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      specialization: json['specialization']?.toString(),
      title: json['title']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      isActive: json['is_active'] == true ||
          json['is_active'] == 1 ||
          json['is_active'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'title': title,
      'photo_url': photoUrl,
      'is_active': isActive,
    };
  }
}
