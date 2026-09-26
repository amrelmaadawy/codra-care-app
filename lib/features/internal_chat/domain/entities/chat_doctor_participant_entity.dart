import 'package:equatable/equatable.dart';

class ChatDoctorParticipantEntity extends Equatable {
  final int id;
  final String name;
  final String? specialization;
  final String? title;
  final String? photoUrl;
  final bool isActive;

  const ChatDoctorParticipantEntity({
    required this.id,
    required this.name,
    this.specialization,
    this.title,
    this.photoUrl,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        specialization,
        title,
        photoUrl,
        isActive,
      ];
}
