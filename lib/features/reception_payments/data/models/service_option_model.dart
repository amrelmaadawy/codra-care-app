import '../../domain/entities/service_option_entity.dart';

class ServiceOptionModel extends ServiceOptionEntity {
  const ServiceOptionModel({
    required super.id,
    required super.name,
    required super.price,
    required super.formattedPrice,
    super.category,
    super.durationMinutes,
  });

  factory ServiceOptionModel.fromJson(Map<String, dynamic> json) {
    return ServiceOptionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      price: json['price']?.toString() ?? '0.00',
      formattedPrice: json['formatted_price'] as String? ?? '',
      category: json['category'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'formatted_price': formattedPrice,
      'category': category,
      'duration_minutes': durationMinutes,
    };
  }
}
