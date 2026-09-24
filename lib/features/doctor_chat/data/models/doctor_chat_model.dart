import '../../domain/entities/doctor_chat_entity.dart';

class DoctorChatModel extends DoctorChatEntity {
  const DoctorChatModel({
    required super.id,
    required super.doctorId,
    required super.doctorName,
    super.doctorSpecialization,
    super.doctorPhoto,
    required super.doctorIsActive,
    required super.unreadByDoctor,
    required super.unreadByReception,
    super.lastMessage,
    super.lastMessageTime,
    super.lastMessageAt,
    super.humanTime,
  });

  factory DoctorChatModel.fromJson(Map<String, dynamic> json) {
    return DoctorChatModel(
      id: json['id'] as int? ?? 0,
      doctorId: json['doctor_id'] as int? ?? 0,
      doctorName: json['doctor_name'] as String? ?? '',
      doctorSpecialization: json['doctor_specialization'] as String?,
      doctorPhoto: json['doctor_photo'] as String?,
      doctorIsActive: json['doctor_is_active'] as bool? ?? false,
      unreadByDoctor: json['unread_by_doctor'] as int? ?? 0,
      unreadByReception: json['unread_by_reception'] as int? ?? 0,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: json['last_message_time'] as String?,
      lastMessageAt: json['last_message_at'] as String?,
      humanTime: json['human_time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_specialization': doctorSpecialization,
      'doctor_photo': doctorPhoto,
      'doctor_is_active': doctorIsActive,
      'unread_by_doctor': unreadByDoctor,
      'unread_by_reception': unreadByReception,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'last_message_at': lastMessageAt,
      'human_time': humanTime,
    };
  }
}
