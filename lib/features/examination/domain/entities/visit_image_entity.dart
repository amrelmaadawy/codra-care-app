import 'package:equatable/equatable.dart';

class VisitImageEntity extends Equatable {
  final int id;
  final String url;
  final String fullUrl;
  final String type;
  final String? description;
  final String? name;
  final int? size;

  const VisitImageEntity({
    required this.id,
    required this.url,
    required this.fullUrl,
    this.type = 'other',
    this.description,
    this.name,
    this.size,
  });

  @override
  List<Object?> get props => [
        id,
        url,
        fullUrl,
        type,
        description,
        name,
        size,
      ];
}
