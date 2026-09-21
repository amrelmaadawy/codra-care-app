import 'package:equatable/equatable.dart';

class DoctorTemplateEntity extends Equatable {
  final int id;
  final String title;
  final String content;
  final String type;

  const DoctorTemplateEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, content, type];
}
