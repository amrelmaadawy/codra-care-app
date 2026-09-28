import '../../domain/entities/appointment_charge_item_entity.dart';

class AppointmentChargeItemModel extends AppointmentChargeItemEntity {
  const AppointmentChargeItemModel({
    required super.id,
    super.serviceId,
    required super.type,
    required super.name,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    required super.status,
    super.createdAt,
  });

  factory AppointmentChargeItemModel.fromJson(Map<String, dynamic> json) {
    return AppointmentChargeItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      serviceId: (json['service_id'] as num?)?.toInt(),
      type: json['type'] as String? ?? 'base_service',
      name: json['name'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: json['unit_price']?.toString() ?? '0.00',
      totalPrice: json['total_price']?.toString() ?? '0.00',
      status: json['status'] as String? ?? 'active',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_id': serviceId,
      'type': type,
      'name': name,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt,
    };
  }
}
