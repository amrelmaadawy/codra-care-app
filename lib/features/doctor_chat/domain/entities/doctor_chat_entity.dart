import 'package:equatable/equatable.dart';

class DoctorChatEntity extends Equatable {
  final int id;
  final int doctorId;
  final String doctorName;
  final String? doctorSpecialization;
  final String? doctorPhoto;
  final bool doctorIsActive;
  final int unreadByDoctor;
  final int unreadByReception;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? lastMessageAt;
  final String? humanTime;

  const DoctorChatEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialization,
    this.doctorPhoto,
    required this.doctorIsActive,
    required this.unreadByDoctor,
    required this.unreadByReception,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageAt,
    this.humanTime,
  });

  DoctorChatEntity copyWith({
    int? id,
    int? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    String? doctorPhoto,
    bool? doctorIsActive,
    int? unreadByDoctor,
    int? unreadByReception,
    String? lastMessage,
    String? lastMessageTime,
    String? lastMessageAt,
    String? humanTime,
  }) {
    return DoctorChatEntity(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization: doctorSpecialization ?? this.doctorSpecialization,
      doctorPhoto: doctorPhoto ?? this.doctorPhoto,
      doctorIsActive: doctorIsActive ?? this.doctorIsActive,
      unreadByDoctor: unreadByDoctor ?? this.unreadByDoctor,
      unreadByReception: unreadByReception ?? this.unreadByReception,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      humanTime: humanTime ?? this.humanTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctorId,
        doctorName,
        doctorSpecialization,
        doctorPhoto,
        doctorIsActive,
        unreadByDoctor,
        unreadByReception,
        lastMessage,
        lastMessageTime,
        lastMessageAt,
        humanTime,
      ];
}
