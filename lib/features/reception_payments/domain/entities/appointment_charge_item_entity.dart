import 'package:equatable/equatable.dart';

class AppointmentChargeItemEntity extends Equatable {
  final int id;
  final int? serviceId;
  final String type;
  final String name;
  final int quantity;
  final String unitPrice;
  final String totalPrice;
  final String status;
  final String? createdAt;

  const AppointmentChargeItemEntity({
    required this.id,
    this.serviceId,
    required this.type,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    this.createdAt,
  });

  bool get isActive => status == 'active';
  bool get isBaseService => type == 'base_service' || type == 'legacy_total';
  bool get isAdditionalService => type == 'additional_service';

  @override
  List<Object?> get props => [
        id,
        serviceId,
        type,
        name,
        quantity,
        unitPrice,
        totalPrice,
        status,
        createdAt,
      ];
}
