import 'package:equatable/equatable.dart';

class QueueDoctorEntity extends Equatable {
  final int id;
  final String name;
  final int count;

  const QueueDoctorEntity({
    required this.id,
    required this.name,
    this.count = 0,
  });

  @override
  List<Object?> get props => [id, name, count];
}
