import 'package:equatable/equatable.dart';

class ServiceOptionEntity extends Equatable {
  final int id;
  final String name;
  final String price;
  final String formattedPrice;
  final String? category;
  final int? durationMinutes;

  const ServiceOptionEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.formattedPrice,
    this.category,
    this.durationMinutes,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        formattedPrice,
        category,
        durationMinutes,
      ];
}
