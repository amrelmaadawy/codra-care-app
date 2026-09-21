import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String role;
  final String accountType;
  final List<String> permissions;
  final String tenantCode;
  final String? phone;
  final String? photoUrl;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accountType,
    required this.permissions,
    required this.tenantCode,
    this.phone,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    accountType,
    permissions,
    tenantCode,
    phone,
    photoUrl,
  ];
}
