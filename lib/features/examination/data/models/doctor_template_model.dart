import '../../domain/entities/doctor_template_entity.dart';

class DoctorTemplateModel extends DoctorTemplateEntity {
  const DoctorTemplateModel({
    required super.id,
    required super.title,
    required super.content,
    required super.type,
  });

  factory DoctorTemplateModel.fromJson(Map<String, dynamic> json) {
    return DoctorTemplateModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: json['type'] as String? ?? 'chief_complaint',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'type': type,
    };
  }
}
